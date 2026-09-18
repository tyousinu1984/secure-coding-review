param(
    [Parameter(Mandatory = $true)]
    [string]$SkillsDirectory
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
$Source = Join-Path $RepoRoot "skill\secure-coding-review"
$Destination = Join-Path $SkillsDirectory "secure-coding-review"

New-Item -ItemType Directory -Force -Path $SkillsDirectory | Out-Null

if (Test-Path $Destination) {
    Remove-Item -Recurse -Force $Destination
}

Copy-Item -Recurse -Force $Source $Destination
Write-Host "Installed secure-coding-review -> $Destination"
