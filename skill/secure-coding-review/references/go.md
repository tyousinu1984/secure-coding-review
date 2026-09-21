# Go Security Review

Apply to `net/http`, Gin, Echo, gRPC services, CLI tools, and other Go code.

## Authorization

Do not equate authentication middleware with authorization.

Check:
- principal propagation via `context.Context`;
- ownership/tenant checks inside handlers, not only at the router;
- gRPC interceptor-based authorization (unary and stream);
- admin routes/services segregated from ordinary user routes.

## SQL / persistence

Review:
- `fmt.Sprintf`/string concatenation used to build SQL;
- `database/sql` queries built without placeholders;
- `sqlx`/GORM `Raw`/`Exec` with unescaped input.

Prefer parameterized queries (`?`/`$1` placeholders) and ORM query builders over raw SQL.

Dynamic table/column names cannot be parameterized; use strict allowlists.

## Command execution

Review:
- `os/exec.Command`/`CommandContext` invoked with a shell (`"sh", "-c", ...`);
- command strings built from external input.

Prefer a fixed executable with a separate argument slice; avoid shell invocation.

## Templates / XSS

`text/template` performs no output escaping; only `html/template` applies contextual escaping.

Flag any HTTP response rendered through `text/template`.

Treat `template.HTML`, `template.JS`, and `template.URL` wrapper types as raw-output APIs and review their inputs.

## SSRF

Review `http.Client`/`http.Get`/`http.Post` calls where the URL or host is externally influenced.

Apply a destination allowlist before dialing; consider a custom `net.Dialer`/`DialContext` to block loopback, link-local, and RFC1918 ranges plus cloud metadata endpoints, and review `CheckRedirect` behavior.

## Path handling

Review `os.Open`/`os.Create`, `filepath.Join`, and `http.ServeFile`/`http.FileServer` where the path is user-controlled.

Use `filepath.Clean` plus an explicit containment check against the intended base directory; stripping `..` alone is not sufficient.

## Deserialization

Be cautious with `encoding/gob` and any dynamic type registry driven by untrusted input.

Prefer `encoding/json` or schema-validated formats for untrusted payloads.

## Concurrency and fail-open bugs

Review goroutines where an authorization/validation check runs separately from the code path that uses its result — a race can let the operation proceed before the check completes.

Do not silently discard errors (`_ = err`) from security-relevant calls (authentication, TLS verification, permission checks); a discarded error commonly becomes fail-open behavior.

## TLS / crypto

Review:
- `tls.Config{InsecureSkipVerify: true}`;
- a custom `VerifyPeerCertificate` that unconditionally returns `nil`;
- disabled/lowered `MinVersion`.

Use `crypto/rand`, never `math/rand`, for tokens, keys, and nonces.

Prefer maintained JWT/signing libraries over hand-rolled verification code; see `oauth-jwt.md`.

## gRPC

Review interceptor-based authentication/authorization on both unary and streaming RPCs.

Verify TLS/mTLS is not disabled for internal-only convenience without review, and that authorization is enforced per method, not only at the connection level.

## Dependencies

Verify `go.mod`/`go.sum` entries correspond to real, intended modules; watch for typosquatted import paths.

Run `govulncheck`.

Review `replace` directives pointing at forks or local paths before merge.

## Logging

Avoid logging full request bodies, tokens, or `Authorization` headers.

Watch for errors from libraries that embed secrets (e.g., DSNs) reaching logs.

## Testing examples

- non-owner request is denied for another user's resource;
- a goroutine race cannot bypass an authorization check;
- SQL/command inputs remain data, not code;
- path traversal cannot escape the base directory;
- disabled TLS verification is rejected in review;
- SSRF target is restricted to allowlisted hosts.
