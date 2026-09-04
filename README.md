# Vibie Data Plugin

Public Codex and Claude Code marketplace for authorized Donuts Bangkok team members. One marketplace
can contain multiple project plugins; it currently bundles Vibie Data with the OAuth-protected,
read-only MCP server at `https://mcp.vibie.live/mcp`.

The repository is only a distribution package for AI clients. It contains no database credential, native binary, PostgreSQL client, or backend source code. Making this repository public does not make Vibie data public: the MCP server still requires Auth0 login with an authorized company account and the `vibie.data.read` scope.

## Install in Codex

Each team member adds the public marketplace once. Run this command in macOS Terminal or Windows PowerShell:

```bash
codex plugin marketplace add https://github.com/donuts-bkk/ai-tools.git
```

No GitLab account or SSH key is required. Then:

1. Restart Codex.
2. Open **Settings → Plugins**.
3. Choose **Vibie Team → Vibie Data** and click **Install**.
4. Complete the Auth0 login with an authorized, verified `@donuts-bkk.com` Google Workspace account.
5. Start a new task and ask a Vibie business-data question.

Codex reads `.mcp.json` from the plugin and requests `vibie.data.read` and
`offline_access`. The MCP OAuth broker handles Auth0's OpenID scopes internally, so each
installation does not create a new Auth0 Application. A ChatGPT connector, ChatGPT
developer-mode app, ChatGPT Business workspace, and OpenAI plugin-directory review are not
part of this installation path.

For a CLI smoke test:

```bash
codex plugin add vibie-data@personal
codex mcp login vibie-data --oauth-client-registration dcr
```

`personal` is the marketplace's technical identifier; its display name in the GUI is **Vibie Team**.

## Install in Claude from GitHub (recommended)

GitHub is the canonical public marketplace host for both Claude and Codex. Add this marketplace once:

```text
/plugin marketplace add https://github.com/donuts-bkk/ai-tools.git
/plugin install vibie-data@ai-tools
/reload-plugins
```

Then run `/mcp`, select Vibie Data, and authenticate with an authorized, verified
`@donuts-bkk.com` Google Workspace account. Future releases use marketplace update/install flows
instead of sending a new ZIP to every employee.

## Install in Claude by uploading a ZIP (fallback)

Use the release ZIP only when GitHub is unavailable or organization policy disables external
marketplaces. It contains only the Claude manifest, hosted MCP configuration, and Vibie Data skill.

1. Download the latest `vibie-data-<version>.zip` from the maintainer.
2. In Claude, open **Customize → Plugins → Add plugin → Upload a plugin**.
3. Select the ZIP and click **Upload**.
4. Open the plugin's MCP connection and click **Authenticate**.
5. Sign in with an authorized, verified `@donuts-bkk.com` Google Workspace account.

The ZIP is installed locally on that Claude Desktop/Cowork installation. To update it, upload a
new ZIP whose manifest has the same plugin name and a newer version; Claude replaces the existing
manual plugin. No GitLab access is required on the employee's machine.

## Install in Claude Code from Git (terminal alternative)

Claude Code uses its own marketplace manifest from the same Git repository. Run these commands in Claude Code:

```text
/plugin marketplace add https://github.com/donuts-bkk/ai-tools.git
/plugin install vibie-data@ai-tools
/reload-plugins
```

Then run `/mcp`, select the Vibie Data server, and complete the OAuth login with an authorized, verified `@donuts-bkk.com` Google Workspace account. The plugin loads the same business-language skill as Codex and requests only `vibie.data.read` and refresh-token access.

The equivalent terminal commands are:

```bash
claude plugin marketplace add https://github.com/donuts-bkk/ai-tools.git
claude plugin install vibie-data@ai-tools
```

### Update in Claude Code

```text
/plugin marketplace update ai-tools
/plugin update vibie-data@ai-tools
/reload-plugins
```

Claude Code uses the semantic version in `.claude-plugin/plugin.json`. Maintainers must bump it for every Claude-facing release.

## Use in Claude or Claude Desktop

Claude and Claude Desktop can use the hosted MCP server directly without installing the Git marketplace:

1. Open **Settings → Connectors**.
2. Choose **Add custom connector**.
3. Enter `Vibie Data` as the name and `https://mcp.vibie.live/mcp` as the connector URL.
4. Click **Connect** and complete the company Auth0 login.
5. Enable the Vibie Data tools from **Search and tools** in a conversation.

The Git plugin's skill instructions are available in Claude Code. Claude and Claude Desktop receive the MCP tools, their safety descriptions, and live business context from the server itself.

## Update an existing Codex installation

Refresh the Git-backed marketplace:

```bash
codex plugin marketplace upgrade personal
```

Then restart Codex, open **Settings → Plugins → Vibie Team → Vibie Data**, and use the GUI update action if shown. Start a new task after updating so Codex loads the new skill and MCP configuration.

To verify the configured marketplace source:

```bash
codex plugin marketplace list
```

## Maintainer workflow

1. Update the Codex package under `plugins/vibie-data` and the Claude package under
   `plugins/vibie-data-claude`. Keep their skill instructions aligned.
2. Bump the Codex cachebuster and the Claude semantic version in their respective `plugin.json` files.
3. Validate and test both the Codex and Claude packages locally.
4. Build the Claude upload fallback with `./scripts/build-claude-upload.sh`.
5. Commit and push source changes to `origin` and the public GitHub mirror. Keep the legacy public
   GitLab.com mirror updated during the migration period. Do not commit `dist/` archives.
6. Team members update through the marketplace. Distribute `dist/vibie-data-<version>.zip` only as
   a fallback through an approved internal channel.

Codex and Claude use separate package directories because their MCP OAuth configuration schemas
differ. Do not put both client MCP files in one plugin directory: Claude's remote marketplace
validator rejects conflicting declarations for the same MCP server name.

The archive must keep `.claude-plugin/plugin.json` at the ZIP root and remain below Anthropic's
50 MB upload limit. The build script validates both conditions.

These Git marketplaces are separate from the OpenAI and Anthropic public directories. Publishing a new Git revision for direct team installation does not require submitting the plugin to either company for review.

## Authentication operations

The production Auth0 configuration, change procedure, incident response, and rollback checklist are maintained privately in the MCP server repository at `docs/AUTH0-RUNBOOK.md`. Do not copy Auth0 credentials, tokens, database URLs, or operational secrets into this public repository.

## Security boundary

- The public repository contains only Codex/Claude plugin metadata, MCP endpoint configuration, and business-language guidance.
- MCP access requires OAuth, an authorized verified company identity, and the `vibie.data.read` scope.
- The MCP server independently enforces read-only SQL, bounded results, Bangkok timezone handling, and PII restrictions.
- Database credentials remain only on the server and are never installed on employee machines.
