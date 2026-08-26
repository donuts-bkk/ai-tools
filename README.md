# Vibie Data Plugin

Private Codex/ChatGPT plugin for authorized Donuts Bangkok team members. It bundles a Vibie business-data skill with the OAuth-protected, read-only MCP server at `https://mcp.vibie.live/mcp`.

No database credential, native binary, PostgreSQL client, or backend repository is installed on employee machines.

## Local installation test

Add this repository as a marketplace once:

```bash
codex plugin marketplace add /absolute/path/to/vibie-data-plugin
```

Then open the Codex app, choose **Plugins**, select **Vibie Team**, and install **Vibie Data**. Authentication happens during installation through Auth0 and accepts authorized `@donuts-bkk.com` accounts.

For a CLI smoke test (the configured scopes are requested automatically):

```bash
codex plugin add vibie-data@personal
codex mcp login vibie-data --oauth-client-registration dcr
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

The source is hosted in the private company GitLab. Each team member adds the marketplace once:

```bash
codex plugin marketplace add git@gitlab.vibie.live:vibie/vibie-data-plugin.git
```

This command is the only initial CLI step. It works in macOS Terminal and Windows
PowerShell after the employee has GitLab access and Git/SSH authentication configured.

Restart the ChatGPT desktop app, open **Plugins**, choose **Vibie Team**, and click
**Install**. Click **Connect** when prompted. The Auth0 flow automatically requests
`vibie.data.read`, `openid`, `email`, `profile`, and `offline_access`; sign in with an
authorized, verified `@donuts-bkk.com` Google Workspace account.

### Updating an existing installation

When a new plugin version is available, refresh the Git-backed marketplace:

```bash
codex plugin marketplace upgrade personal
```

Then restart the desktop app, open **Plugins → Vibie Team → Vibie Data**, and use the
GUI update action shown for the new version. Start a new task after updating so Codex
loads the new skill and MCP configuration.

To verify which marketplace sources are configured, run:

```bash
codex plugin marketplace list
```

## Security

- The plugin contains no database URL or secret.
- MCP access uses OAuth and requires the `vibie.data.read` scope.
- The server enforces read-only SQL, bounded results, Bangkok timezone, and PII restrictions.
- Do not make this repository public unless company policy explicitly approves the skill instructions and metadata for public distribution.
