# Usage Examples

## Example 1 — Secure API change

Request:

> Add an endpoint that returns a user profile by ID.

Expected skill behavior:
1. identify object-level authorization as security-sensitive;
2. inspect the project's existing authorization model;
3. implement the endpoint using the existing mechanism;
4. review the diff;
5. add a negative test where User A requests User B's profile;
6. produce a Security Gate.

## Example 2 — AI adds a dependency

Request:

> Add a small package for parsing a new file format.

Expected behavior:
1. verify whether a new dependency is actually necessary;
2. verify package identity before installation where possible;
3. run the relevant dependency audit;
4. check whether install/build scripts increase supply-chain risk;
5. record unverified package status rather than assuming safety.

## Example 3 — AWS Terraform change

Request:

> Allow the application to read objects from the report bucket.

Expected behavior:
1. identify IAM/S3 changes as security-sensitive;
2. prefer bucket/prefix-specific read permissions;
3. flag unnecessary wildcard actions/resources;
4. run IaC scanning if available;
5. preserve least privilege;
6. require review if cross-account or sensitive-data access is involved.
