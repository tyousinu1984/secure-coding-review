# Docker / Kubernetes Security Review

Apply to Dockerfiles, container images, Docker Compose, Kubernetes manifests/Helm charts, and container runtime configuration.

## Dockerfile

Review:
- base image tag pinning (avoid `latest` for security-sensitive builds; prefer a pinned digest `image@sha256:...`);
- the `USER` directive (avoid running as root without justification);
- multi-stage builds to keep build secrets/toolchains out of the final image;
- `COPY` vs `ADD` (`ADD`'s remote-URL and auto-extract behavior is riskier);
- secrets passed via `ARG`/`ENV` (persist in image history/layers) instead of a build-time secret mount.

Prefer minimal/distroless base images for security-sensitive services.

## Image build / supply chain

Review unauthenticated or unpinned base images from unfamiliar registries.

Check for embedded credentials, private keys, or `.git`/`.env` files copied into the image.

Prefer image vulnerability scanning (e.g., `trivy image`) and provenance/signature verification where the project requires it.

## Container runtime

Flag:
- `privileged: true`;
- `hostNetwork` / `hostPID` / `hostIPC`;
- `hostPath` volume mounts, especially to sensitive host paths;
- `allowPrivilegeEscalation: true`;
- missing `readOnlyRootFilesystem` for workloads that do not need write access;
- containers running as root without justification;
- unnecessary retained Linux capabilities (`CAP_SYS_ADMIN`, `CAP_NET_ADMIN`, etc.).

Prefer a least-capability `securityContext`, a non-root `runAsUser`, and seccomp/AppArmor profiles where supported.

## Kubernetes RBAC

Review:
- `ClusterRole`/`ClusterRoleBinding` wildcards (`resources: ["*"]`, `verbs: ["*"]`);
- `cluster-admin` binding scope;
- `automountServiceAccountToken` for workloads that never call the API server;
- cross-namespace access.

Prefer namespace-scoped `Role`/`RoleBinding` with explicit resource/verb lists.

## Secrets

Kubernetes `Secret` objects are base64-encoded, not encrypted, by default — verify encryption at rest or an external secret manager integration where required.

Avoid secrets in `ConfigMap`s, environment variables baked into images, or plain YAML committed to the repository.

Review who can read a given `Secret` via RBAC, and mounted secret-volume file permissions.

## Networking

Review `NetworkPolicy` presence for namespaces handling sensitive data; default-allow east-west traffic is a common gap.

Flag `Service`/`Ingress` resources that expose an internal-only workload externally.

Check `Ingress` TLS configuration and certificate management.

## Docker Compose

Review `privileged`, `network_mode: host`, bind-mounted host paths, and hardcoded secrets in `environment:`/committed `.env` files.

Prefer Compose `secrets:` or an external secret manager over plaintext environment values for production-like configuration.

## Admission control / policy

Review whether cluster policy (OPA/Gatekeeper, Kyverno, Pod Security Admission/Standards) actually blocks the risky patterns above, or whether manifests rely solely on manual review.

## Testing examples

- deployment is rejected by policy (or review) when `privileged: true` is set without justification;
- a pod without an explicit RBAC grant cannot read/list `Secret`s in another namespace;
- `NetworkPolicy` denies unexpected cross-namespace traffic;
- inspecting image layer history shows no embedded credentials.
