# Vibie Data Plugin

Private Codex/ChatGPT plugin for authorized Donuts Bangkok team members. It bundles a Vibie business-data skill with the OAuth-protected, read-only MCP server at `https://mcp.vibie.live/mcp`.

No database credential, native binary, PostgreSQL client, or backend repository is installed on employee machines.

## Local installation test

Add this repository as a marketplace once:

```bash
codex plugin marketplace add /absolute/path/to/vibie-data-plugin
```

Then open the Codex app, choose **Plugins**, select **Vibie Team**, and install **Vibie Data**. Authentication happens during installation through Auth0 and accepts authorized `@donuts-bkk.com` accounts.

For a CLI smoke test:

```bash
codex plugin add vibie-data@personal
codex mcp login vibie-data --oauth-client-registration dcr --scopes vibie.data.read,openid,email,profile,offline_access
```

The login command opens Auth0 in the browser. Sign in with an authorized, verified
`@donuts-bkk.com` Google Workspace account. Restart Codex and start a new task after
installing, logging in, or updating the plugin.

## Auth0 prerequisites

Codex registers an OAuth client for the installed MCP connection. Configure the Auth0 tenant in this order before testing login:

1. Open the `Vibie Data MCP` API and authorize `vibie.data.read` under **Default Permissions for Third Party Apps → User-Delegated Access**.
2. Promote the Google Workspace connection to a domain-level connection so dynamically registered clients can use it.
3. Keep the Post Login Action that requires a verified `@donuts-bkk.com` account and adds the namespaced email claims.
4. Open **Settings → Advanced** and enable **Dynamic Client Registration (DCR)** last.

Auth0 DCR is open client registration. Keep the default API grant limited to the read-only `vibie.data.read` scope, retain user consent, and use Auth0 ACL controls if the organization needs tighter registration restrictions.

## Team distribution

Host this repository in the company GitHub organization, then team members can add the marketplace once:

```bash
codex plugin marketplace add vibe2/vibie-data-plugin
codex plugin add vibie-data@personal
codex mcp login vibie-data --oauth-client-registration dcr --scopes vibie.data.read,openid,email,profile,offline_access
```

To remove the per-machine marketplace command entirely, a ChatGPT workspace admin can publish the tested local plugin to selected workspace roles from the Plugins management page. Workspace members can then install it directly from the Codex/ChatGPT Plugins Directory.

## Security

- The plugin contains no database URL or secret.
- MCP access uses OAuth and requires the `vibie.data.read` scope.
- The server enforces read-only SQL, bounded results, Bangkok timezone, and PII restrictions.
- Do not make this repository public unless company policy explicitly approves the skill instructions and metadata for public distribution.
