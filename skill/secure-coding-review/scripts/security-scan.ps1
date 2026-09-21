param(
    [string]$Target = ".",
    [string]$OutDir = "security-reports"
)

$ErrorActionPreference = "Continue"
$ScriptDir = Split-Path -Parent $PSCommandPath
$SecretConfig = Join-Path $ScriptDir "..\configs\trivy-secret.yaml"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

Write-Host "[secure-coding-review] target: $Target"
Write-Host "[secure-coding-review] reports: $OutDir"

$ran = $false

if (Get-Command semgrep -ErrorAction SilentlyContinue) {
    Write-Host "[+] Running Semgrep"
    if ((Test-Path (Join-Path $Target ".semgrep.yml")) -or (Test-Path (Join-Path $Target ".semgrep.yaml"))) {
        semgrep scan --json $Target | Out-File -Encoding utf8 "$OutDir/semgrep.json"
    } else {
        semgrep scan --config auto --json $Target | Out-File -Encoding utf8 "$OutDir/semgrep.json"
    }
    $ran = $true
} else {
    Write-Host "[-] Semgrep not installed"
}

if (Get-Command trivy -ErrorAction SilentlyContinue) {
    Write-Host "[+] Running Trivy filesystem scan (vuln, secret, misconfig)"
    $TrivyArgs = @("fs", "--scanners", "vuln,secret,misconfig", "--format", "json", "--output", "$OutDir/trivy.json")
    if (Test-Path $SecretConfig) {
        Write-Host "[+] Using project secret rules: $SecretConfig"
        $TrivyArgs += @("--secret-config", $SecretConfig)
    }
    $TrivyArgs += $Target
    trivy @TrivyArgs
    $ran = $true
} else {
    Write-Host "[-] Trivy not installed"
}

if (Get-Command gitleaks -ErrorAction SilentlyContinue) {
    Write-Host "[+] Running Gitleaks"
    gitleaks detect --source $Target --report-format json --report-path "$OutDir/gitleaks.json"
    $ran = $true
} else {
    Write-Host "[-] Gitleaks not installed"
}

if ((Test-Path "$Target/package-lock.json") -and (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "[+] Running npm audit"
    Push-Location $Target
    npm audit --json | Out-File -Encoding utf8 "../$OutDir/npm-audit.json"
    Pop-Location
    $ran = $true
}

if ((Test-Path "$Target/go.mod") -and (Get-Command govulncheck -ErrorAction SilentlyContinue)) {
    Write-Host "[+] Running govulncheck"
    Push-Location $Target
    govulncheck -json ./... | Out-File -Encoding utf8 "../$OutDir/govulncheck.json"
    Pop-Location
    $ran = $true
}

if (((Test-Path "$Target/requirements.txt") -or (Test-Path "$Target/pyproject.toml")) -and
    (Get-Command pip-audit -ErrorAction SilentlyContinue)) {
    Write-Host "[+] Running pip-audit"
    Push-Location $Target
    pip-audit -f json | Out-File -Encoding utf8 "../$OutDir/pip-audit.json"
    Pop-Location
    $ran = $true
}

if (-not $ran) {
    Write-Host "[!] No supported scanner was found."
    Write-Host "[!] Security Gate must be INCOMPLETE unless equivalent checks are performed elsewhere."
    exit 2
}

Write-Host "[+] Scan invocation complete."
Write-Host "[!] Scanner findings require triage; do not treat raw findings as confirmed vulnerabilities."
