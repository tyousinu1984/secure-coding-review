# Common Secure Coding Rules

## Evidence model

Classify each finding as:
- Confirmed
- Likely
- Possible
- Needs verification

A finding should include:
- exact location;
- attacker-controlled source where relevant;
- security-sensitive sink/operation;
- intervening validation/authorization;
- realistic impact;
- smallest secure remediation;
- verification method.

## Authentication

Check:
- token/session validation;
- expiration;
- revocation where applicable;
- signature validation;
- audience/issuer validation where applicable;
- password-reset/recovery flows;
- session fixation/rotation;
- cookie flags.

Never treat possession of an object identifier as authorization.

## Authorization

Check authorization at the server side and near the protected resource/action.

Review:
- object ownership;
- tenant boundaries;
- horizontal privilege escalation;
- vertical privilege escalation;
- admin-only actions;
- mass assignment of privileged fields.

Prefer deny-by-default where practical.

## Input handling

Treat data from these as untrusted:
- HTTP requests;
- headers/cookies;
- files;
- queues;
- webhooks;
- third-party APIs;
- environment/config values controlled outside the process;
- repository content consumed by autonomous agents.

Validation does not replace contextual output encoding or parameterized APIs.

## Error handling

Do not expose:
- stack traces;
- secrets;
- connection strings;
- internal filesystem paths;
- private service topology;
- detailed authentication failure reasons that materially aid attackers.

Preserve enough server-side telemetry for investigation.

## Logging

Log security-relevant events, such as:
- authentication success/failure;
- authorization denial;
- privileged operation;
- security policy change;
- suspicious validation failure.

Do not log:
- passwords;
- full bearer tokens;
- private keys;
- raw session secrets;
- unnecessary personal/sensitive data.

Use correlation/request IDs where available.

## Secrets

Secrets belong in an approved secret-management mechanism, not source code.

On detecting a real secret:
1. redact it in output;
2. recommend rotation;
3. check commit/history exposure if relevant;
4. remove it from code/config;
5. avoid printing it in test logs.

## Dependencies

For newly introduced dependencies:
- verify the package actually exists;
- verify the ecosystem/name;
- avoid unnecessary packages;
- prefer maintained libraries;
- audit known vulnerabilities;
- avoid executing untrusted install/build hooks where unnecessary.

Do not accept AI-suggested dependencies solely because the name sounds plausible.

## Cryptography

Prefer maintained standard libraries and documented constructions.

Review:
- weak/deprecated algorithms;
- static IV/nonce;
- predictable randomness;
- hardcoded keys;
- custom cryptographic constructions;
- missing signature/certificate verification.

Escalate uncertain cryptographic correctness for human/specialist review.
