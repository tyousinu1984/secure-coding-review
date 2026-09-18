# Security Policy

## Reporting a vulnerability

Please do not disclose a suspected vulnerability in this project through a normal public issue.

Preferred reporting method:
1. use GitHub private vulnerability reporting if it is enabled for the repository;
2. otherwise contact the repository maintainer privately through the contact method published on the maintainer's GitHub profile before sharing sensitive details.

Include:
- affected version/commit;
- affected file or component;
- reproduction conditions;
- impact;
- minimal proof of concept when safe;
- suggested mitigation if known.

Do not include:
- credentials;
- personal data;
- data obtained from systems you do not own or lack authorization to test.

## Scope

Reports about the project itself are in scope, including:
- command injection in included scripts;
- unsafe handling of repository-controlled input;
- secret exposure;
- unsafe CI/workflow behavior;
- vulnerabilities that could cause a coding agent to perform unintended privileged actions.

Findings in third-party scanners or dependencies should normally be reported to the relevant upstream project unless this repository introduces additional exposure.

## Responsible testing

Only test systems and repositories you own or are explicitly authorized to assess.
