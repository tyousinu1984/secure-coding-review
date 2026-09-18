# AWS / IaC Security Review

Apply to Terraform, CloudFormation, CDK output, AWS SDK usage, IAM, S3, networking, Lambda/ECS/EKS, and CI/CD.

## IAM

Apply least privilege.

Review:
- `"Action": "*"`
- `"Resource": "*"`
- broad managed policies;
- `iam:PassRole`;
- role assumption trust policies;
- cross-account principals;
- wildcard KMS/Secrets Manager permissions.

Wildcards are not automatically vulnerabilities, but require explicit justification and scope review.

## S3

Review:
- public access;
- bucket policies;
- ACL usage;
- encryption requirements;
- cross-account access;
- presigned URL lifetime;
- logging/data classification.

Do not disable Block Public Access unless public access is explicitly required and reviewed.

## Security groups / networking

Flag unexpected:
- `0.0.0.0/0` or `::/0` inbound to sensitive ports;
- unrestricted database/admin ports;
- broad east-west access.

Public HTTP(S) ingress may be intended; judge by service role.

Review egress when workloads handle untrusted URLs or sensitive data.

## Secrets

Prefer:
- Secrets Manager;
- SSM Parameter Store with appropriate protections;
- workload identity/roles.

Avoid long-lived static AWS credentials in:
- source;
- container images;
- CI variables where short-lived federation is available;
- logs.

## CloudTrail / security telemetry

Avoid disabling or reducing:
- CloudTrail;
- audit logging;
- security findings;
- critical WAF/log streams

without explicit operational justification.

## KMS

Review:
- key policies;
- grants;
- cross-account access;
- broad decrypt privileges.

Encryption is not useful if decrypt permission is effectively universal.

## Lambda

Review:
- execution role;
- environment-variable secrets;
- public Function URLs;
- event-source trust;
- outbound network behavior;
- dependency packaging.

## ECS / EKS / containers

Review:
- privileged containers;
- host networking/PID/IPC;
- hostPath mounts;
- root user;
- writable root filesystem;
- Kubernetes RBAC wildcards;
- service account token access;
- image provenance/tags.

## Terraform / IaC

Security review should include generated plan/config changes, not only source snippets.

Use deterministic scanners where available:
- `trivy config`;
- policy-as-code tools used by the project.

## SSRF and metadata service

For workloads issuing requests based on external input, consider exposure to:
- instance metadata;
- internal service endpoints;
- link-local/private networks.

Use architecture-level protections as well as application validation where applicable.

## Logging/data lake considerations

Security logs should preserve raw evidence and access control.

When centralizing logs:
- separate source/raw data from normalized analysis data;
- restrict mutation/deletion;
- encrypt;
- define retention;
- record access;
- avoid logging application secrets.
