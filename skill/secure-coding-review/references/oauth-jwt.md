# OAuth / OIDC / JWT Security Review

Apply to authentication/authorization flows built on OAuth 2.0, OpenID Connect, and JWT-based tokens, independent of language or framework.

## JWT validation

Verify the signature using the expected algorithm and a trusted key; never let the token's own `alg` header select the verification method.

Explicitly reject `alg: none`.

Reject algorithm confusion: if the application expects RS256, it must not accept an HS256 token verified using the RS256 public key as the HMAC secret.

Validate `exp`, `nbf`, and `iat` with reasonable clock-skew tolerance.

Validate `iss` and `aud` against expected values; a token minted for a different service or tenant must not be accepted.

Do not decode a JWT and trust its claims (roles, user ID, tenant) before the signature is verified.

## Token storage and transport

Prefer httpOnly, `Secure`, `SameSite` cookies for browser-held tokens over `localStorage`/`sessionStorage`, which are exposed to XSS.

Review whether access tokens are sent only over TLS and only to intended origins; watch for leakage via `Referer`, logs, or third-party redirects.

Prefer short-lived access tokens with refresh-token rotation over long-lived access tokens.

## Refresh tokens

Rotate refresh tokens on use where the provider/library supports it; detect and revoke on reuse of an already-rotated token (replay detection).

Store refresh tokens server-side or in httpOnly cookies, not in client-readable storage.

Confirm there is a working revocation path (logout, compromise response, password change) that actually invalidates refresh/session tokens.

## OAuth 2.0 / OIDC flow

Require PKCE for authorization-code flows, especially for public clients (SPA/mobile).

Validate `state` to prevent CSRF on the callback endpoint.

Validate `redirect_uri` against an exact allowlist; do not accept prefix/substring matches or open patterns.

Avoid the implicit grant flow for new integrations; prefer authorization code plus PKCE.

Verify the OIDC `nonce` when the implicit/hybrid flow is still in use.

## Scopes and claims

Do not treat requested scope as granted scope; verify what the authorization server actually issued.

Map external identity-provider claims (roles/groups) explicitly; an IdP-supplied claim must not silently grant elevated internal privileges without a defined mapping.

Review third-party/social-login account linking for account-takeover risk (e.g., linking by an unverified email address).

## Session integration

Where JWTs back a session, ensure logout/session invalidation actually prevents further use of the token (deny-list, short expiry, or a session-bound reference token), rather than relying on client-side deletion alone.

Issue a new session/token after login rather than reusing a pre-auth identifier (session fixation).

## Multi-tenant / service-to-service tokens

Verify a token issued for one tenant/service cannot be replayed against another tenant's resources; check `aud`/tenant claims at the resource server, not only at the gateway.

For service-to-service (client-credentials) tokens, apply least-privilege scopes per caller rather than one shared broad-scope token.

## Common library pitfalls

Confirm the JWT library version is not affected by known algorithm-confusion or signature-bypass issues.

Avoid hand-rolled JWT parsing/verification; use a maintained library's documented verification API rather than manual base64 decode plus comparison.

## Testing examples

- a token with `alg: none` is rejected;
- a token signed with the wrong key/algorithm is rejected;
- an expired token is rejected;
- a token issued for a different audience/tenant is rejected;
- a `state` mismatch on the OAuth callback is rejected;
- a `redirect_uri` outside the allowlist is rejected;
- a reused/rotated refresh token is rejected and triggers revocation;
- logout actually invalidates the session/token for subsequent requests.
