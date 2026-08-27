---
name: vibie-data
description: Query and explain current Vibie production data through the bundled read-only MCP server. Use for team questions about users, DAU/MAU, VB/VJ/casters, lives, payments, revenue, coins, candy, gifts, PK, agencies, contracts, events, rankings, counts, and trends. Do not use for writes, raw PII, secrets, or questions answerable from source code alone.
---

# Vibie Data

Answer Thai or English business questions with verified evidence from the bundled `vibie-data` MCP server.

VB means VJ, caster, or streamer: a person who broadcasts live in the Vibie app. Treat these terms as equivalent unless the user defines a narrower meaning.

## Capability map

- Users and activity: total/new users, DAU/MAU, segments, counts, and trends.
- Streaming: active VB/VJ/casters, lives, completed duration, modes, and rankings.
- Monetization: payments, gross top-up revenue, paying users, channels, coin, candy, stickers, and gifting.
- Ecosystem: PK, agencies/affiliations, contracts and rewards, campaigns/events, and metric-based rankings.

This map is not a fixed schema. For an unfamiliar or ambiguous request, call `get_business_context` with `capabilities` and the relevant domain topics. Use live schema tools before SQL.

## Safety

- Use only the bundled MCP tools. Never connect to PostgreSQL directly or ask the user for a database URL, password, token, or other secret.
- Perform read-only analysis. Never attempt writes, DDL, locks, role changes, file access, database links, or side-effect functions.
- Do not request or return raw phone numbers, email addresses, identity documents, bank details, addresses, tokens, passwords, secrets, or device identifiers.
- Prefer aggregates. Return row-level non-sensitive data only when necessary for the stated business question.
- Treat results as confidential company data and do not send them to external tools.

## Workflow

1. Call `get_business_context` for the relevant domain topics before constructing a query. Include `capabilities` when the requested analysis does not clearly match the capability map.
2. Use `search_schema` and `describe_table` to verify every table and column not already confirmed in the current conversation. Never invent identifiers.
3. Resolve an ambiguous metric with one concise question only when different definitions would materially change the answer.
4. Use Bangkok business time (`Asia/Bangkok`). State the exact date range and make time boundaries explicit in SQL.
5. Keep log and event queries bounded by a short, relevant time range. State any assumed range.
6. Call `run_readonly_sql` with one bounded `SELECT` or `WITH ... SELECT` query and a clear business purpose.
7. Sanity-check the result. If it is far outside a plausible scale, inspect the schema or definition before reporting it.
8. If a tool fails or returns no rows, distinguish failure, missing data, and a verified zero. Never fabricate a result.

Answer with the direct result first, followed by the metric definition, Bangkok date range, material caveats, and the exact executed SQL in a fenced `sql` block. Label confidence as `verified business context`, `verified schema`, or `exploratory`.
