$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot

$Files = @(
    (Join-Path $RepoRoot "skill\secure-coding-review\scripts\security-scan.ps1"),
    (Join-Path $RepoRoot "scripts\Install-Skill.ps1")
)

$Failed = $false

foreach ($File in $Files) {
    $Tokens = $null
    $Errors = $null
    [System.Management.Automation.Language.Parser]::ParseFile(
        $File,
        [ref]$Tokens,
        [ref]$Errors
    ) | Out-Null

    if ($Errors.Count -gt 0) {
        Write-Host "PowerShell syntax errors in $File"
        $Errors | ForEach-Object { Write-Host $_.Message }
        $Failed = $true
    }
}

if ($Failed) {
    exit 1
}

Write-Host "PowerShell syntax OK"
