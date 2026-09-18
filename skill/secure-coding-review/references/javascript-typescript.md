# JavaScript / TypeScript Security Review

Apply to Node.js, Express, NestJS, Next.js server code, browser code, and TypeScript services.

## Authorization

Do not equate middleware authentication with authorization.

Check:
- object ownership;
- tenant membership;
- role/permission enforcement;
- server actions/API routes;
- GraphQL resolver authorization.

Client-side checks are not security boundaries.

## SQL / NoSQL

SQL:
- avoid query string interpolation;
- use parameterized APIs/query builders.

NoSQL:
- prevent untrusted operators/objects from being passed directly to queries;
- validate expected primitive/object shapes.

## Command execution

Review:
- `child_process.exec`
- `execSync`
- shell-enabled spawn variants

Prefer `spawn`/`execFile` with a fixed executable and separated argument array.

## XSS

Review:
- `innerHTML`
- `outerHTML`
- `insertAdjacentHTML`
- `dangerouslySetInnerHTML`
- template rendering
- URL-based DOM sinks

Prefer text APIs/framework escaping.
Sanitization must match the actual context.

## Prototype pollution / object merge

Review untrusted object keys entering:
- deep merge;
- config objects;
- dynamic property assignment.

Reject dangerous keys and prefer schema validation.

## SSRF

Review:
- `fetch`
- Axios
- node HTTP clients
- proxy endpoints

Apply a destination policy when host/URL is externally controlled.
Consider redirect behavior.

## File/path

Review:
- `fs`
- path joins/resolution;
- uploads;
- archive extraction.

Do not trust `originalname` from multipart uploads as a filesystem path.

## JWT/session

Check:
- algorithm handling;
- signature verification;
- expiration;
- issuer/audience where relevant;
- cookie flags;
- session rotation.

Do not decode a JWT and treat decoded claims as authenticated without verification.

## Dependencies

Verify npm package:
- exact spelling;
- maintenance;
- necessity;
- known vulnerabilities.

Pay particular attention to AI-suggested low-profile packages and lifecycle/install scripts.

## Next.js / frontend-server boundaries

Be explicit about what executes:
- in browser;
- server-side;
- server action;
- API route.

Never expose server secrets through client bundles or public environment-variable conventions.

## Testing examples

- user A cannot access user B data;
- admin API denied to non-admin;
- XSS payload remains escaped;
- untrusted URL cannot proxy to internal network;
- query operators cannot be injected through request JSON.
