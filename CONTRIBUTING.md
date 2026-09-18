# Contributing

Thank you for helping improve `secure-coding-review`.

## Contribution principles

Security rules should be:
- evidence-based;
- specific enough to be actionable;
- conservative about exploitability claims;
- clear about false-positive conditions;
- compatible with the project's `Confirmed / Likely / Possible / Needs verification` model.

Avoid adding rules that simply label every use of a sensitive API as a vulnerability.

## Good contributions

Examples:
- framework-specific authorization checks;
- data-flow patterns with source/sink reasoning;
- negative security-test patterns;
- scanner adapters;
- false-positive reductions;
- clearer remediation guidance;
- language/platform references.

## Pull requests

Before opening a PR:

1. keep the change focused;
2. update documentation when behavior changes;
3. run repository checks;
4. do not include real credentials, exploit data from real targets, or sensitive customer information;
5. explain security assumptions and expected false-positive tradeoffs.

Run:

```bash
python tests/test_structure.py
bash -n skill/secure-coding-review/scripts/security-scan.sh
bash -n scripts/install-skill.sh
bash -n scripts/package-skill.sh
```

## Security-rule PRs

When adding a new rule or pattern, include:

- threat/risk addressed;
- vulnerable pattern;
- conditions required for exploitability;
- safe pattern or remediation;
- likely false positives;
- suggested verification/test.

## Scanner integration

Scanner integrations must not convert raw scanner findings directly into confirmed vulnerabilities.

The integration should preserve:
- tool name;
- execution status;
- relevant rule/finding ID;
- location;
- raw evidence where appropriate;
- triage status.

## Style

Use concise Markdown.
Prefer examples over abstract statements.
Do not embed real secrets or production identifiers.
