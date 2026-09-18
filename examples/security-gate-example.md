# Example Security Gate

```text
Security Gate: FAIL

Summary:
The change introduces a confirmed object-level authorization gap.
No critical issues were found, but this issue should block merge.

Findings:
- Critical: 0
- High: 1
- Medium: 1
- Low: 0

HIGH — Missing object-level authorization

Status:
Confirmed

Location:
src/main/kotlin/example/UserController.kt:74

Category:
CWE-639 / Broken Access Control

Evidence:
The authenticated endpoint accepts `userId` from the request path
and returns the corresponding user record. No ownership, tenant, or
administrator authorization check occurs before the response is returned.

Attack conditions:
The attacker needs a valid ordinary user account and another user's ID.

Impact:
An authenticated user may read another user's profile.

Recommendation:
Apply the existing resource-authorization policy before returning the object.

Verification:
Add a test where User A requests User B's resource and verify that access
is denied according to application policy.

MEDIUM — Authorization header logged at debug level

Status:
Confirmed

Location:
src/main/kotlin/example/RequestLogger.kt:31

Evidence:
The complete Authorization header is interpolated into a debug log message.

Recommendation:
Do not log bearer credentials. Log only non-sensitive request metadata.

Checks performed:
- Diff review: completed
- SAST: Semgrep completed
- Dependency scan: Trivy completed
- Secret scan: Gitleaks completed
- Security tests: authorization regression test required

Residual risk:
Business authorization policy requires maintainer confirmation.

Human review:
Required
```
