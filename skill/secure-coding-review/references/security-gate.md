# Security Gate Output

Use this format for security-sensitive changes.

## Gate values

### PASS
No material security issue was identified, relevant checks completed, and no blocking verification remains.

### PASS WITH WARNINGS
No blocking issue is confirmed, but residual risk or manual review remains.

### FAIL
A confirmed or strongly supported issue should block merge/deployment.

Typical examples:
- authorization bypass;
- SQL/command injection;
- exposed real production secret;
- disabled TLS verification;
- privilege escalation;
- public exposure of sensitive data.

### INCOMPLETE
Important checks could not be performed or required context is unavailable.

Do not convert INCOMPLETE into PASS merely because no issue was found.

---

## Output template

Security Gate: <PASS | PASS WITH WARNINGS | FAIL | INCOMPLETE>

Summary:
<1-3 sentences>

Findings:
- Critical: N
- High: N
- Medium: N
- Low: N

### [Severity] <Finding title>

Status:
<Confirmed | Likely | Possible | Needs verification>

Location:
`path:line` or configuration/resource identifier

Category:
<CWE / OWASP category if confidently applicable>

Evidence:
<exact code/config/data-flow evidence>

Attack conditions:
<what an attacker must control or already possess>

Impact:
<realistic impact>

Recommendation:
<smallest secure remediation>

Verification:
<test or check proving remediation>

Checks performed:
- Diff review: <completed/not available>
- SAST: <tool/result/not executed>
- Dependency scan: <tool/result/not executed>
- Secret scan: <tool/result/not executed>
- IaC scan: <tool/result/not applicable/not executed>
- Security tests: <executed/not executed>

Residual risk:
<what still requires human/runtime/specialist verification>

Human review:
<required/recommended/not specifically required>
