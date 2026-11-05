param(
  [Parameter(Mandatory = $true)][string]$SourcePath,
  [Parameter(Mandatory = $true)][string]$Version
)
$ErrorActionPreference = "Stop"
$Repo = "MrCutLAST/Codev-OFFICIAL"
$Source = (Resolve-Path $SourcePath).Path
$Package = Join-Path $Source "package.json"
$VersionFile = Join-Path $Source "VERSION.txt"
if (!(Test-Path $Package) -or !(Test-Path $VersionFile)) { throw "SourcePath must contain package.json and VERSION.txt." }
$PackageVersion = (Get-Content $Package -Raw | ConvertFrom-Json).version
$FileVersion = (Get-Content $VersionFile -Raw).Trim()
if ($PackageVersion -ne $Version -or $FileVersion -ne $Version) { throw "Version mismatch: package.json=$PackageVersion VERSION.txt=$FileVersion requested=$Version." }
if (!(Get-Command gh -ErrorAction SilentlyContinue)) { throw "Install GitHub CLI: winget install --id GitHub.cli" }
if (!(Get-Command node -ErrorAction SilentlyContinue)) { throw "Install Node.js 22 or newer." }
if (!(Get-Command tar.exe -ErrorAction SilentlyContinue)) { throw "Windows tar.exe is required." }
gh auth status --hostname github.com
if ($LASTEXITCODE -ne 0) { throw "Sign in first with: gh auth login" }

# The local key is DPAPI-protected for this Windows user and is also stored as a GitHub Actions secret.
$KeyDirectory = Join-Path $env:APPDATA "Codev"
$KeyFile = Join-Path $KeyDirectory "release-source-key.dpapi"
New-Item -ItemType Directory -Force $KeyDirectory | Out-Null
if (Test-Path $KeyFile) {
  $ProtectedKey = (Get-Content $KeyFile -Raw).Trim()
  $SecureKey = ConvertTo-SecureString $ProtectedKey
  $Pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureKey)
  try { $Key = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($Pointer) }
  finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($Pointer) }
} else {
  $Bytes = New-Object byte[] 32
  $Rng = [Security.Cryptography.RandomNumberGenerator]::Create()
  $Rng.GetBytes($Bytes)
  $Rng.Dispose()
  $Key = [Convert]::ToBase64String($Bytes)
  $SecureKey = ConvertTo-SecureString $Key -AsPlainText -Force
  Set-Content -Path $KeyFile -Value (ConvertFrom-SecureString $SecureKey) -NoNewline
}
gh secret set CODEV_SOURCE_KEY --repo $Repo --body $Key
if ($LASTEXITCODE -ne 0) { throw "Could not save CODEV_SOURCE_KEY in GitHub Actions secrets." }
$env:CODEV_SOURCE_KEY = $Key

# Refuse an already-used version before uploading or replacing any release input.
gh api "repos/$Repo/git/ref/tags/v$Version" *> $null
if ($LASTEXITCODE -eq 0) { throw "Tag v$Version already exists. Increase the version before releasing." }

$Temp = Join-Path $env:TEMP ("codev-release-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force $Temp | Out-Null
$Archive = Join-Path $Temp "Codev-source.zip"
$Encrypted = Join-Path $Temp "Codev-source.zip.enc"
try {
  & tar.exe -a -c -f $Archive -C $Source --exclude=.git --exclude=*/.git --exclude=node_modules --exclude=*/node_modules --exclude=release --exclude=out --exclude=dist --exclude=.env --exclude=.env.* --exclude=*.pem --exclude=*.key --exclude=*.p12 --exclude=*.pfx --exclude=*.log --exclude=*.sqlite --exclude=*.db .
  if ($LASTEXITCODE -ne 0) { throw "Could not create source archive." }
  $ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
  node (Join-Path $ScriptRoot "encrypt-source.mjs") $Archive $Encrypted
  if ($LASTEXITCODE -ne 0 -or !(Test-Path $Encrypted)) { throw "Could not encrypt source archive." }

  gh release view codev-source-bundle --repo $Repo *> $null
  if ($LASTEXITCODE -ne 0) {
    gh release create codev-source-bundle --repo $Repo --draft --target main --title "Encrypted Codev build input" --notes "Private build input. AES-256-GCM encrypted. Keep this release as a draft."
    if ($LASTEXITCODE -ne 0) { throw "Could not create encrypted source draft release." }
  }
  gh release upload codev-source-bundle $Encrypted --repo $Repo --clobber
  if ($LASTEXITCODE -ne 0) { throw "Could not upload encrypted source bundle." }

  $MainSha = gh api "repos/$Repo/git/ref/heads/main" --jq ".object.sha"
  if ($LASTEXITCODE -ne 0 -or !$MainSha) { throw "Could not resolve Codev-OFFICIAL main branch." }
  gh api --method POST "repos/$Repo/git/refs" -f "ref=refs/tags/v$Version" -f "sha=$MainSha"
  if ($LASTEXITCODE -ne 0) { throw "Could not create release tag v$Version." }
  Write-Host ""
  Write-Host "Encrypted source uploaded to a DRAFT release. No plaintext source was uploaded."
  Write-Host "Release workflow started for v$Version: https://github.com/$Repo/actions"
} finally {
  Remove-Item -Recurse -Force $Temp -ErrorAction SilentlyContinue
  Remove-Item Env:CODEV_SOURCE_KEY -ErrorAction SilentlyContinue
}
