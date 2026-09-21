# Roadmap

The roadmap is directional and may change based on contributions.

## v0.3 — Open-source foundation

- repository/community structure;
- reusable skill package;
- Java/Kotlin reference;
- Python reference;
- JavaScript/TypeScript reference;
- AWS/IaC reference;
- AI-generated-code threat guidance;
- Semgrep/Trivy/Gitleaks audit wrapper;
- Security Gate format;
- repository structure tests.

## v0.4 — Coverage expansion

Included:
- Go security reference;
- Docker/Kubernetes reference;
- OAuth/OIDC/JWT deep-dive;
- database security reference.

Planned:
- file-upload/storage reference;
- CI/CD supply-chain reference.

## v0.5 — Scanner adapters

Planned:
- CodeQL guidance;
- Semgrep rule packs;
- scanner result normalization;
- machine-readable Security Gate schema;
- baseline / new-findings-only mode;
- SARIF ingestion.

## v0.6 — AI coding workflow

Planned:
- pre-generation risk classification;
- pre-commit review mode;
- pull-request review mode;
- changed-files/diff-scoped analysis;
- framework-aware negative test generation.

## Related future project

A separate `security-incident-investigator` skill is planned for:

- WAF logs;
- access logs;
- CloudTrail;
- CloudWatch/application logs;
- event correlation;
- attack timelines;
- IOC extraction;
- evidence-based incident reports.

The two projects may later share:
- evidence models;
- severity definitions;
- report schemas;
- security-data normalization conventions.
