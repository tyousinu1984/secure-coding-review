# Java / Kotlin Security Review

Apply to Spring Boot, Jakarta/Spring Security, JVM services, Android/backend Kotlin, and related code.

## Authorization

In Spring-based systems, check:
- route/controller security;
- method-level authorization;
- service-layer enforcement;
- ownership/tenant checks;
- differences between `authenticated()` and actual authorization.

Be cautious when:
- a controller loads by arbitrary path ID;
- `@PreAuthorize`/security annotations are removed or broadened;
- admin/user routes share a service without policy enforcement.

Do not assume hiding a route in the UI provides authorization.

## SQL / persistence

Review:
- JDBC string concatenation;
- `EntityManager.createNativeQuery`;
- dynamic JPQL/HQL;
- jOOQ/raw SQL;
- MyBatis `${...}` substitutions.

Prefer:
- prepared statements;
- bind parameters;
- safe ORM query builders.

For multi-tenant systems, verify tenant criteria cannot be omitted.

## Spring MVC / WebFlux input

Treat as untrusted:
- `@RequestParam`
- `@PathVariable`
- `@RequestBody`
- headers/cookies
- multipart files

Use request DTOs rather than binding external input directly to persistence entities, especially when entities contain privileged fields.

## SSRF

Review:
- `RestTemplate`
- `WebClient`
- Java `HttpClient`
- OkHttp
- URL/URI construction

If URL/host is user-controlled, apply destination policy before the request and consider redirects.

## Process execution

Review:
- `Runtime.getRuntime().exec`
- `ProcessBuilder`

Avoid invoking shells with concatenated strings.
Use fixed executable plus separated arguments.

## Files

Review:
- `Paths.get`
- `Path.resolve`
- `Files.read/write/delete`
- multipart original filenames
- ZIP/JAR extraction

Normalize/canonicalize and enforce containment within the intended base directory.

## Serialization

Be cautious with:
- native Java serialization;
- overly permissive Jackson polymorphic typing;
- deserialization into privileged domain objects.

Prefer explicit DTO schemas.

## Spring Security configuration

Flag changes that:
- broadly use `permitAll`;
- disable CSRF without architecture-specific justification;
- weaken session policy;
- accept unsigned/incorrectly validated JWTs;
- weaken CORS;
- remove method authorization.

CSRF decisions must reflect whether browser credentials/cookies are used; do not mechanically require or disable it.

## Logging

For SLF4J/logback:
- avoid tokens/passwords;
- avoid logging full Authorization headers;
- use structured/correlation fields where possible;
- avoid log injection where untrusted newline/control characters matter.

## Kotlin-specific notes

Review nullable/default behavior and data-class binding:
- default values must not accidentally grant privilege;
- `copy()` calls should not bypass authorization/business invariants;
- `!!` is primarily reliability risk, but may become security-relevant if failure produces fail-open behavior.

## Testing examples

Authorization:
- authenticated non-owner requests another user's resource -> 403/404 according to policy;
- ordinary user invokes admin operation -> denied.

JWT/session:
- expired token -> denied;
- wrong signature -> denied;
- wrong issuer/audience where enforced -> denied.

Persistence:
- injection payload is treated as literal input;
- tenant A cannot query tenant B records.
