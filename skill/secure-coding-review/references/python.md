# Python Security Review

Apply to Django, Flask, FastAPI, scripts, workers, automation, and Python services.

## SQL

Review:
- string formatting in SQL;
- f-strings passed to database execute;
- `%` interpolation;
- dynamically constructed SQL identifiers.

Prefer driver/ORM parameter binding.

Dynamic table/column names cannot usually be parameterized; use strict allowlists.

## Command execution

Review:
- `os.system`
- `subprocess.*`
- `shell=True`
- command strings built from external input

Prefer:
- `subprocess.run([...], shell=False, check=True, ...)`;
- fixed executable;
- separated arguments.

`shell=True` with attacker-influenced data is high risk.

## Web frameworks

Django:
- preserve CSRF protections for cookie-based browser flows;
- review `mark_safe`, raw SQL, redirects, upload handling;
- check object-level authorization.

Flask/FastAPI:
- verify authentication dependency/middleware applies to routes;
- verify authorization separately from authentication;
- validate uploaded data and outbound URLs.

## Serialization / code execution

Treat as high risk with untrusted input:
- `pickle`
- `marshal`
- unsafe YAML loaders
- `eval`
- `exec`

Prefer JSON or schema-validated formats.

For YAML, use safe loaders unless trusted-only data is guaranteed.

## Path handling

Review:
- `open`
- `pathlib.Path`
- archive extraction;
- user-supplied filenames.

Resolve and confirm the final path remains beneath the approved base path.

## SSRF

Review:
- `requests`
- `httpx`
- `aiohttp`
- urllib clients

Apply destination restrictions for attacker-controlled URLs.
Do not rely solely on string prefix checks.

## Templates / XSS

Preserve template autoescaping.
Treat explicit safe/HTML wrappers and manually generated HTML as security-sensitive.

## Secrets

Review:
- `.env` committed to repository;
- settings/config modules;
- hardcoded keys;
- debug output.

Environment variables are not automatically safe if they are printed or exposed.

## Dependency checks

Consider:
- `pip-audit`
- lockfiles;
- hashes/pinning according to project policy.

Verify AI-suggested PyPI package names before install.

## Testing examples

- non-owner object access denied;
- malformed/hostile input rejected safely;
- subprocess arguments remain separate;
- path traversal cannot escape base directory;
- internal/private SSRF targets are rejected;
- unsafe serialized payload is never executed.
