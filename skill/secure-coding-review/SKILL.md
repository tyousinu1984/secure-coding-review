---
name: secure-coding-review
description: Security guardrail and review workflow for AI-assisted software development. Use when writing, modifying, refactoring, or reviewing application code, APIs, authentication or authorization logic, database access, file handling, network calls, cloud/IaC configuration, dependencies, secrets, cryptography, or other security-sensitive code. Also use when reviewing AI-generated code, pull requests, diffs, or security scan findings.
---

# Secure Coding Review

Apply this workflow to security-sensitive coding and review tasks.

The purpose of this skill is to combine:
- secure-by-design reasoning;
- review of the actual code diff;
- deterministic scanners where available;
- targeted negative/security tests;
- evidence-based security findings;
- explicit residual-risk reporting.

Do not treat this skill as a replacement for SAST, dependency scanners, secret scanners, penetration testing, or human review.

## 1. Classify the change

Before implementation, determine whether the change touches any of these areas:

- authentication or session management;
- authorization, roles, permissions, tenancy, object ownership;
- external/user-controlled input;
- SQL/database access;
- file upload, storage, archive extraction, filesystem paths;
- outbound HTTP/network access;
- shell/process execution;
- secrets or credentials;
- cryptography;
- dependency changes;
- logging of sensitive data;
- cloud/IaC/IAM/firewall/Kubernetes/Docker configuration;
- CI/CD or build scripts;
- AI-agent/tool/MCP execution permissions.

For ordinary low-risk changes, avoid unnecessary security ceremony.

For security-sensitive changes, load and apply:
- `references/common-rules.md`
- `references/vulnerability-patterns.md`
- `references/ai-generated-code.md`

Also load the relevant language/platform reference:
- Java/Kotlin: `references/java-kotlin.md`
- Python: `references/python.md`
- JavaScript/TypeScript: `references/javascript-typescript.md`
- Go: `references/go.md`
- AWS/IaC: `references/aws-security.md`
- Docker/Kubernetes: `references/docker-kubernetes.md`
- OAuth/OIDC/JWT: `references/oauth-jwt.md`
- Database (SQL/NoSQL): `references/database-security.md`

## 2. Establish security invariants

Before writing code, identify the security properties that must remain true.

Examples:
- only the owner or an authorized admin may read this object;
- external input must never become executable SQL;
- an uploaded filename must never control the final filesystem path;
- user-controlled URLs must not reach internal/private network addresses;
- secrets must not enter source control or logs;
- no new IAM wildcard permission may be added without justification.

Keep these invariants concise and relevant to the requested change.

## 3. Implement the smallest secure change

Follow the existing application's established security architecture.

Prefer:
- framework-supported security controls;
- parameterized APIs;
- centralized authorization;
- existing validators;
- least privilege;
- explicit allowlists where suitable;
- safe defaults;
- fail-closed behavior for sensitive operations.

Do not weaken an existing security control merely to make implementation or tests pass.

## 4. Review the actual diff

After implementation, inspect the resulting diff.

Check for:
- changed trust boundaries;
- missing or weakened authorization;
- dangerous data-flow paths;
- new network destinations;
- new process execution;
- new dependencies;
- secrets;
- logging changes;
- IAM/firewall/security-group changes;
- deleted or weakened tests;
- unrelated/out-of-scope edits.

Do not rely only on what was intended to be changed.

## 5. Trace suspicious data flows

Use:

`Source -> transformations -> validation -> authorization -> sink`

Examples:

`HTTP parameter -> controller -> service -> repository -> SQL`

`Webhook field -> URL builder -> HTTP client -> internal endpoint`

`Uploaded filename -> path join -> file write`

A dangerous API alone is not proof of exploitability.
Confirm whether attacker-controlled input can reach it and what controls intervene.

## 6. Run available security checks

If available, use `scripts/security-scan.sh` or `scripts/security-scan.ps1`.

The scripts may invoke installed tools such as:
- Semgrep;
- Trivy;
- Gitleaks;
- language-native dependency audit commands.

Treat scanner output as evidence requiring triage, not as unquestionable truth.

Never claim a scanner ran if it was unavailable or not executed.

## 7. Add targeted security tests

For material risks, add or recommend attacker-oriented negative tests.

Examples:
- User A cannot read User B's resource.
- Non-admin cannot call an admin endpoint.
- `../` cannot escape the permitted upload directory.
- SQL metacharacters remain data.
- user-controlled URLs cannot reach metadata/private network endpoints.
- expired or invalidly signed tokens are rejected.

Do not create large generic security suites unrelated to the change.

## 8. Produce a Security Gate

Use `references/security-gate.md`.

Allowed gate results:
- PASS
- PASS WITH WARNINGS
- FAIL
- INCOMPLETE

Separate:
- confirmed findings;
- likely findings;
- possible findings;
- items needing verification.

For high-risk authentication, authorization, cryptography, payment, destructive, or privileged logic, require human review even when automated checks pass.

## Non-negotiable rules

Never silently:
- disable authentication or authorization;
- disable TLS certificate/hostname verification;
- disable CSRF protections;
- broaden CORS to `*` for credentialed/sensitive APIs;
- suppress security exceptions to get tests green;
- remove security tests;
- weaken assertions to accept insecure behavior;
- hardcode credentials;
- broaden IAM privileges without justification.

Never invent:
- CVEs;
- scanner results;
- exploitability;
- package legitimacy;
- runtime behavior not supported by evidence.

Redact secrets in all output.
