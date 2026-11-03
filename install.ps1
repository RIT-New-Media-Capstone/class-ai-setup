# Set up opencode for class (Windows PowerShell).
#
#   powershell -ExecutionPolicy RemoteSigned -File install.ps1
#   powershell -ExecutionPolicy RemoteSigned -File install.ps1 -Setup amurica
#   ... -DryRun   shows what it would do and changes nothing
#
# What it does, and nothing else:
#   1. Points opencode at the class config INSIDE this folder (OPENCODE_CONFIG,
#      a user environment variable), so `git pull` here is all it takes when
#      the class setup changes.
#   2. Saves your OpenRouter key as OPENROUTER_API_KEY, if it isn't set yet.
# Your own opencode config is not touched.

param(
  [string]$Setup = 'spaceballs',
  [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$configDir = Join-Path $PSScriptRoot 'configs'
$configPath = Join-Path $configDir "$Setup.json"

if (-not (Test-Path $configPath)) {
  Write-Host "No setup called '$Setup'. Choose one of:"
  Get-ChildItem $configDir -Filter *.json | ForEach-Object { '  ' + $_.BaseName }
  exit 1
}
$configPath = (Resolve-Path $configPath).Path

function Set-UserVariable([string]$Name, [string]$Value, [string]$Shown) {
  if ($DryRun) { Write-Host "[dry run] would set user variable $Name = $Shown"; return }
  [Environment]::SetEnvironmentVariable($Name, $Value, 'User')
  Write-Host "Set user variable $Name = $Shown"
}

Set-UserVariable 'OPENCODE_CONFIG' $configPath "$configPath"

$existingKey = [Environment]::GetEnvironmentVariable('OPENROUTER_API_KEY', 'User')
if ($existingKey -or $env:OPENROUTER_API_KEY) {
  Write-Host 'OPENROUTER_API_KEY is already set; keeping it.'
} elseif ($DryRun) {
  Write-Host '[dry run] would ask for your OpenRouter key and save it as OPENROUTER_API_KEY'
} else {
  $secure = Read-Host 'Paste the OpenRouter key your instructor gave you (Enter to skip)' -AsSecureString
  $plain = [Runtime.InteropServices.Marshal]::PtrToStringBSTR(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure))
  if (-not $plain) {
    Write-Host 'Skipped. Run this again when you have your key.'
  } elseif ($plain -notlike 'sk-or-*') {
    Write-Host "That doesn't look like an OpenRouter key (they start with sk-or-). Skipped."
  } else {
    Set-UserVariable 'OPENROUTER_API_KEY' $plain '(your key, hidden)'
  }
  $plain = $null
}

if (Get-Command opencode -ErrorAction SilentlyContinue) {
  Write-Host "opencode is installed: $(opencode --version 2>$null | Select-Object -First 1)"
} else {
  Write-Host "opencode isn't installed yet. In Git Bash, run:  curl -fsSL https://opencode.ai/install | bash"
}

Write-Host ''
Write-Host 'Next:'
Write-Host '  1. Close this window and open a NEW terminal (so the settings load).'
Write-Host '  2. Check it:  opencode models'
Write-Host '     You should see exactly four "class/@preset/..." models.'
Write-Host '  3. Start working:  cd into a project folder and run  opencode'
