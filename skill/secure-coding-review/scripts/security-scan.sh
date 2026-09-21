#!/usr/bin/env bash
set -uo pipefail

TARGET="${1:-.}"
OUT_DIR="${2:-security-reports}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SECRET_CONFIG="$SCRIPT_DIR/../configs/trivy-secret.yaml"

mkdir -p "$OUT_DIR"

echo "[secure-coding-review] target: $TARGET"
echo "[secure-coding-review] reports: $OUT_DIR"

ran=0

if command -v semgrep >/dev/null 2>&1; then
  echo "[+] Running Semgrep"
  # Use the project's configured rules when present. Otherwise use Semgrep's auto config.
  if [ -f "$TARGET/.semgrep.yml" ] || [ -f "$TARGET/.semgrep.yaml" ]; then
    semgrep scan --json "$TARGET" > "$OUT_DIR/semgrep.json" || true
  else
    semgrep scan --config auto --json "$TARGET" > "$OUT_DIR/semgrep.json" || true
  fi
  ran=1
else
  echo "[-] Semgrep not installed"
fi

if command -v trivy >/dev/null 2>&1; then
  echo "[+] Running Trivy filesystem scan (vuln, secret, misconfig)"
  trivy_args=(fs --scanners vuln,secret,misconfig --format json --output "$OUT_DIR/trivy.json")
  if [ -f "$SECRET_CONFIG" ]; then
    echo "[+] Using project secret rules: $SECRET_CONFIG"
    trivy_args+=(--secret-config "$SECRET_CONFIG")
  fi
  trivy "${trivy_args[@]}" "$TARGET" || true
  ran=1
else
  echo "[-] Trivy not installed"
fi

if command -v gitleaks >/dev/null 2>&1; then
  echo "[+] Running Gitleaks"
  gitleaks detect \
    --source "$TARGET" \
    --report-format json \
    --report-path "$OUT_DIR/gitleaks.json" || true
  ran=1
else
  echo "[-] Gitleaks not installed"
fi

# Ecosystem-native dependency audits.
# These are run only when both the manifest/lockfile and the tool are present.

if [ -f "$TARGET/package-lock.json" ] && command -v npm >/dev/null 2>&1; then
  echo "[+] Running npm audit"
  (cd "$TARGET" && npm audit --json) > "$OUT_DIR/npm-audit.json" || true
  ran=1
fi

if [ -f "$TARGET/go.mod" ] && command -v govulncheck >/dev/null 2>&1; then
  echo "[+] Running govulncheck"
  (cd "$TARGET" && govulncheck -json ./...) > "$OUT_DIR/govulncheck.json" || true
  ran=1
fi

if { [ -f "$TARGET/requirements.txt" ] || [ -f "$TARGET/pyproject.toml" ]; } \
   && command -v pip-audit >/dev/null 2>&1; then
  echo "[+] Running pip-audit"
  (cd "$TARGET" && pip-audit -f json) > "$OUT_DIR/pip-audit.json" || true
  ran=1
fi

if [ "$ran" -eq 0 ]; then
  echo "[!] No supported scanner was found."
  echo "[!] Security Gate must be INCOMPLETE unless equivalent checks are performed elsewhere."
  exit 2
fi

echo "[+] Scan invocation complete."
echo "[!] Scanner findings require triage; do not treat raw findings as confirmed vulnerabilities."
