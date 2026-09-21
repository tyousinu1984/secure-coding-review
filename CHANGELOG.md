# Changelog

All notable project changes should be recorded here.

## [0.4.0] - 2026-09-21

### Added
- Go security reference.
- Docker/Kubernetes security reference.
- OAuth/OIDC/JWT security reference.
- Database security reference (SQL/NoSQL).

### Fixed
- `security-scan.sh`/`security-scan.ps1` now detect a Semgrep config relative to the scan `TARGET` instead of the current working directory.
- `security-scan.sh`/`security-scan.ps1` now pass `configs/trivy-secret.yaml` to Trivy via `--secret-config` when present, so project-specific secret rules take effect.

## [0.3.0] - 2026-09-16

### Added
- GitHub/open-source repository structure.
- Community contribution and security policies.
- Issue and pull-request templates.
- CI structure validation.
- Installation and packaging scripts.
- Architecture, threat-model, and roadmap documentation.
- Usage and Security Gate examples.

### Included from 0.2
- Core `SKILL.md`.
- Common secure-coding rules.
- Vulnerability-pattern reference.
- AI-generated-code security reference.
- Java/Kotlin, Python, JavaScript/TypeScript, and AWS/IaC references.
- Semgrep/Trivy/Gitleaks/ecosystem scan wrappers.
- Security Gate format.
