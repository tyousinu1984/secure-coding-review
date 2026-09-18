# Architecture

## Goal

`secure-coding-review` is an orchestration and reasoning layer, not a replacement security scanner.

The intended model is:

```text
Developer request
       |
       v
Security-sensitive change detection
       |
       v
Security invariants
       |
       v
AI-assisted implementation
       |
       v
Actual diff review
       |
       +-------------------+
       |                   |
       v                   v
Data-flow reasoning   Deterministic scanners
       |                   |
       +---------+---------+
                 |
                 v
          Finding triage
                 |
                 v
        Targeted security tests
                 |
                 v
           Security Gate
                 |
                 v
            Human review
```

## Separation of responsibilities

### AI / skill layer

Best suited for:
- understanding the requested change;
- identifying trust boundaries;
- reasoning across files;
- detecting business-logic authorization gaps;
- mapping scanner evidence to the actual change;
- explaining risk and remediation;
- generating targeted negative tests.

### Deterministic tools

Best suited for:
- repeatable pattern matching;
- taint/data-flow queries;
- known vulnerable dependency detection;
- secret detection;
- IaC/configuration checks.

### Human reviewer

Responsible for:
- accepting residual risk;
- reviewing high-risk design decisions;
- verifying business authorization policy;
- approving security-sensitive release/deployment decisions.

## Skill package

`skill/secure-coding-review/SKILL.md` controls the workflow.

Detailed knowledge is split into references so hosts can load only relevant material:
- common rules;
- vulnerability patterns;
- language/platform guidance;
- AI-specific risks;
- Security Gate output contract.

## Security Gate

The gate is deliberately four-state rather than binary:

- `PASS`
- `PASS WITH WARNINGS`
- `FAIL`
- `INCOMPLETE`

`INCOMPLETE` prevents "nothing was detected" from being misrepresented as "the code is secure".
