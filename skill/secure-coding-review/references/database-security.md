# Database Security Review

Apply to relational databases (PostgreSQL, MySQL, SQL Server, etc.), NoSQL stores (MongoDB, DynamoDB, Redis), and ORM-mediated data access.

## Query construction

Prefer parameterized queries, prepared statements, or ORM query builders over string-built SQL; see the language-specific guidance in `python.md`, `java-kotlin.md`, `javascript-typescript.md`, and `go.md`.

Dynamic identifiers (table/column/sort-by names) cannot be parameterized; validate them against a strict allowlist rather than interpolating directly.

Treat raw/native query escape hatches (`.raw()`, `createNativeQuery`, MongoDB `$where`) as high-risk even inside an otherwise ORM-based codebase.

## Multi-tenancy and row-level access

Verify tenant/owner filtering is enforced for every access path to a table, not only in one primary code path — a second controller, background job, or admin tool querying the same table is a common gap.

Prefer database-enforced isolation (row-level security, per-tenant schema, or a query-layer wrapper that cannot be bypassed) over relying on every caller remembering a `WHERE tenant_id = ?` clause.

Review whether soft-deleted or archived rows are excluded consistently across all query paths.

## Least privilege

Application database users should not hold superuser/owner privileges; separate migration/admin credentials from the runtime application user.

Review whether the application user can `DROP`/`ALTER`/`GRANT` when it only needs `SELECT`/`INSERT`/`UPDATE`/`DELETE` on specific tables.

For NoSQL, review IAM/database-user scoping (e.g., DynamoDB IAM policy per table/action, MongoDB role per database).

## Migrations

Review destructive migrations (`DROP COLUMN`, `DROP TABLE`, data-deleting backfills) for reversibility and blast radius, especially against production-sized tables.

Flag migration scripts that embed real credentials, PII, or environment-specific secrets.

Confirm migrations run with a distinct, appropriately scoped credential rather than the broadest one available.

## Encryption and sensitive fields

Review whether sensitive fields (PII, credentials, payment data, health data) are encrypted at rest according to project/compliance policy, at the field or storage-engine level.

Confirm TLS is enforced for database connections, especially over untrusted networks.

Backups and read replicas should carry the same access-control and encryption requirements as the primary.

## NoSQL-specific

MongoDB: treat unsanitized objects passed into query filters as operator-injection risk (`$where`, `$ne`, `$gt` supplied by request JSON); validate expected shape/types before querying.

Redis: review commands built from untrusted input (`EVAL` with untrusted scripts), and whether an internal Redis instance is reachable from untrusted networks.

DynamoDB: review IAM condition keys for row-level restriction (e.g., `dynamodb:LeadingKeys`) rather than relying solely on application-layer filtering.

## Connection handling

Review connection strings/DSNs for embedded credentials in source, logs, or error messages.

Confirm connection pooling does not leak one tenant's transaction/session state into another request, especially with session-scoped settings such as PostgreSQL's `SET search_path` in multi-tenant designs.

## Logging and query telemetry

Do not log full query parameter values that may contain secrets or sensitive PII by default; scrub before persisting slow-query/audit logs.

Preserve enough query telemetry (which table, which principal) for investigation without capturing raw sensitive payloads.

## Testing examples

- tenant A's query cannot return tenant B's rows, including through a second/less-common code path;
- dynamic sort/filter parameters outside the allowlist are rejected;
- the application database user cannot perform schema-altering statements;
- a NoSQL operator-injection payload is rejected or treated as a literal value;
- a destructive migration is reviewed against production data volume before merge.
