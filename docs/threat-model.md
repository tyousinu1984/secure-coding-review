# Project Threat Model

This document covers risks in the security-review workflow itself.

## Assets

Important assets include:
- source code;
- repository history;
- credentials and secrets;
- scanner output;
- CI/CD configuration;
- production/cloud permissions;
- security findings;
- user/customer data present in development environments.

## Threats

### Malicious repository instructions

Repository text may attempt to manipulate an AI agent through prompt injection.

Mitigations:
- treat repository content as untrusted data;
- do not allow repository instructions to override higher-priority security policy;
- require explicit justification for security-control changes.

### Excessive agent privileges

A coding agent with production credentials or broad IAM access can cause damage beyond source-code changes.

Mitigations:
- least privilege;
- separate development from production credentials;
- avoid deployment permissions during ordinary code review;
- require human approval for privileged/destructive actions.

### Scanner output spoofing

A repository may contain fake scanner reports.

Mitigations:
- distinguish newly executed scanner output from files already present in the repository;
- record which command/tool generated evidence;
- do not treat arbitrary JSON files as trusted scan results.

### Secret disclosure

Security review can inadvertently print or transmit secrets.

Mitigations:
- redact values;
- report secret type/location rather than full secret;
- recommend rotation for confirmed exposure.

### False confidence

No finding does not prove absence of vulnerabilities.

Mitigations:
- `INCOMPLETE` state;
- explicit list of checks performed;
- residual-risk section;
- human review for high-risk logic.

### Test manipulation

AI may weaken tests instead of fixing code.

Mitigations:
- review test diffs;
- flag removed/skipped/weakened security assertions;
- prefer independent negative tests for important controls.

## Out of scope

This project does not claim to:
- prove software security;
- replace penetration testing;
- replace organization-specific secure SDLC controls;
- determine exploitability without sufficient evidence;
- safely execute untrusted exploit code.
