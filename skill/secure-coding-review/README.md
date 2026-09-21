# Skill Package

This directory is the distributable `secure-coding-review` skill. For project-level documentation, contribution rules, and roadmap, see the repository root.

# secure-coding-review

A reusable security workflow for AI-assisted coding.

## Structure

```text
secure-coding-review/
├── SKILL.md
├── references/
│   ├── common-rules.md
│   ├── vulnerability-patterns.md
│   ├── ai-generated-code.md
│   ├── java-kotlin.md
│   ├── python.md
│   ├── javascript-typescript.md
│   ├── go.md
│   ├── aws-security.md
│   ├── docker-kubernetes.md
│   ├── oauth-jwt.md
│   ├── database-security.md
│   └── security-gate.md
├── scripts/
│   ├── security-scan.sh
│   └── security-scan.ps1
└── configs/
    └── trivy-secret.yaml
```

## Design

The main skill file stays small and controls the workflow.

Detailed security knowledge is loaded only when relevant:
- common security rules;
- vulnerability/data-flow patterns;
- AI-specific risks;
- language/platform rules;
- Security Gate reporting.

The scan scripts integrate with tools already installed in the environment rather than implementing a new scanner.

Supported opportunistic integrations:
- Semgrep
- Trivy
- Gitleaks
- npm audit
- govulncheck
- pip-audit

Missing tools are reported rather than silently treated as a successful scan.

## Recommended workflow

1. Identify whether a code change is security-sensitive.
2. Establish security invariants.
3. Implement the smallest secure change.
4. Review the actual diff.
5. Trace important untrusted-data flows.
6. Run deterministic scanners.
7. Add targeted negative/security tests.
8. Triage findings.
9. Produce the Security Gate.
10. Require human review for high-risk logic.

## Suggested future modules

- `references/file-upload.md`
- `references/cicd-supply-chain.md`
- `references/codeql.md`
- `references/semgrep.md`
- `references/incident-response.md`

The incident-response/log-investigation workflow is best maintained as a separate skill and can later share common evidence/severity/reporting resources with this skill.
