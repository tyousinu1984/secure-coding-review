# Secure Coding Review Skill

An open-source security guardrail for AI-assisted software development.

`secure-coding-review` helps an AI coding agent reason about security **before**, **during**, and **after** a code change. It combines secure-coding rules, diff review, targeted security tests, and deterministic scanner output into an evidence-based **Security Gate**.

> Status: early-stage / experimental. This project does not replace professional security review, penetration testing, SAST/DAST, or incident response.

## Why this project exists

AI coding assistants can increase development speed, but they can also introduce or amplify risks such as:

- missing authorization checks;
- unsafe input-to-sink data flows;
- hallucinated or unnecessary dependencies;
- weakened security configuration;
- test manipulation to make insecure behavior pass;
- secret leakage;
- over-broad cloud/IAM permissions;
- security regressions hidden inside large AI-generated diffs.

This project provides a reusable workflow that makes those risks explicit and reviewable.

## What it does

The skill guides an AI coding workflow through:

1. **Change classification** — identify security-sensitive changes.
2. **Security invariants** — define what must remain true.
3. **Secure implementation** — prefer safe framework and platform primitives.
4. **Diff review** — inspect what actually changed.
5. **Data-flow analysis** — reason from attacker-controlled sources to sensitive sinks.
6. **Scanner integration** — consume evidence from Semgrep, Trivy, Gitleaks, and ecosystem audit tools when available.
7. **Targeted negative tests** — verify authorization and unsafe-input boundaries.
8. **Security Gate** — report `PASS`, `PASS WITH WARNINGS`, `FAIL`, or `INCOMPLETE`.

## Repository layout

```text
.
├── skill/
│   └── secure-coding-review/
│       ├── SKILL.md
│       ├── references/
│       ├── scripts/
│       └── configs/
├── docs/
│   ├── architecture.md
│   ├── threat-model.md
│   └── roadmap.md
├── examples/
│   ├── usage.md
│   └── security-gate-example.md
├── tests/
├── scripts/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   ├── workflows/
│   └── pull_request_template.md
├── CONTRIBUTING.md
├── SECURITY.md
├── CODE_OF_CONDUCT.md
├── CHANGELOG.md
└── LICENSE
```

## Quick start

Copy the skill directory into the skill directory used by your AI coding environment:

```bash
./scripts/install-skill.sh /path/to/your/skills
```

or on Windows:

```powershell
.\scripts\Install-Skill.ps1 -SkillsDirectory "C:\path\to\your\skills"
```

You can also copy `skill/secure-coding-review/` manually.

The hosting AI environment must support a skill/instruction workflow that can read the referenced files. Exact installation paths differ between hosts.

## Scanner support

The included scan wrapper opportunistically uses tools already installed on the machine:

- Semgrep
- Trivy
- Gitleaks
- `npm audit`
- `govulncheck`
- `pip-audit`

Example:

```bash
cd your-project
/path/to/secure-coding-review/scripts/security-scan.sh . security-reports
```

A missing scanner is **not** treated as a successful scan. If important checks cannot be performed, the Security Gate should remain `INCOMPLETE`.

## Design principles

### Evidence before claims

The skill must distinguish:

- Confirmed
- Likely
- Possible
- Needs verification

It must not invent CVEs, scanner results, exploitability, package legitimacy, or runtime behavior.

### AI review is not independent proof

The same AI that generated a bug may reproduce the same assumption during self-review. Deterministic scanners, targeted tests, runtime evidence, and human review remain important.

### Preserve raw evidence

Scanner output and the actual code diff should remain available for verification. Summaries should not replace source evidence.

### Small secure changes

The workflow prefers the smallest secure modification over broad AI-generated refactors.

## Supported areas

Current references cover:

- common application security;
- Java / Kotlin;
- Python;
- JavaScript / TypeScript;
- AWS / IaC;
- AI-generated-code-specific risks;
- common vulnerability/data-flow patterns.

See the [roadmap](docs/roadmap.md) for planned modules.

## Example Security Gate

```text
Security Gate: FAIL

High: 1
Medium: 1

HIGH — Missing object-level authorization

Status: Confirmed
Location: src/UserController.kt:74

Evidence:
The endpoint loads a resource from an attacker-controlled path ID
without checking whether the authenticated principal may access it.

Verification:
User A requests User B's resource and must receive 403/404
according to application policy.
```

See [examples/security-gate-example.md](examples/security-gate-example.md) for a fuller example.

## Contributing

Contributions are welcome, especially:

- language/framework security references;
- vulnerability patterns with concrete evidence requirements;
- scanner adapters;
- false-positive reductions;
- security regression test examples;
- cloud/IaC rules.

Read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request.

## Security

Do **not** publish a suspected vulnerability in this project as a normal public issue.

See [SECURITY.md](SECURITY.md).

## License

MIT. See [LICENSE](LICENSE).
