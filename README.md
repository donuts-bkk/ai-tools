# Vibie Data Plugin

Public Codex plugin for authorized Donuts Bangkok team members. It bundles the Vibie business-data skill with the OAuth-protected, read-only MCP server at `https://mcp.vibie.live/mcp`.

The repository is only a distribution package for Codex. It contains no database credential, native binary, PostgreSQL client, or backend source code. Making this repository public does not make Vibie data public: the MCP server still requires Auth0 login with an authorized company account and the `vibie.data.read` scope.

## Install in Codex

Each team member adds the public marketplace once. Run this command in macOS Terminal or Windows PowerShell:

```bash
codex plugin marketplace add https://gitlab.vibie.live/vibie/vibie-data-plugin.git
```

No GitLab account or SSH key is required. Then:

1. Restart Codex.
2. Open **Settings → Plugins**.
3. Choose **Vibie Team → Vibie Data** and click **Install**.
4. Complete the Auth0 login with an authorized, verified `@donuts-bkk.com` Google Workspace account.
5. Start a new task and ask a Vibie business-data question.

Codex reads `.mcp.json` from the plugin and automatically requests `vibie.data.read`, `openid`, `email`, `profile`, and `offline_access`. A ChatGPT connector, ChatGPT developer-mode app, ChatGPT Business workspace, and OpenAI plugin-directory review are not part of this installation path.

For a CLI smoke test:

```bash
codex plugin add vibie-data@personal
codex mcp login vibie-data --oauth-client-registration dcr
```

`personal` is the marketplace's technical identifier; its display name in the GUI is **Vibie Team**.

## Update an existing installation

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

1. Update the plugin files under `plugins/vibie-data`.
2. Bump the plugin version in `plugins/vibie-data/.codex-plugin/plugin.json`.
3. Validate and test the plugin locally.
4. Commit and push to the default branch.
5. Team members run the marketplace upgrade command and update through the GUI.

This Git marketplace is separate from the Universal Plugins Directory. Publishing a new Git revision does not require submitting the plugin to OpenAI for review.

## Authentication operations

The production Auth0 configuration, change procedure, incident response, and rollback checklist are maintained privately in the MCP server repository at `docs/AUTH0-RUNBOOK.md`. Do not copy Auth0 credentials, tokens, database URLs, or operational secrets into this public repository.

## Security boundary

- The public repository contains only plugin metadata, MCP endpoint configuration, and business-language guidance.
- MCP access requires OAuth, an authorized verified company identity, and the `vibie.data.read` scope.
- The MCP server independently enforces read-only SQL, bounded results, Bangkok timezone handling, and PII restrictions.
- Database credentials remain only on the server and are never installed on employee machines.
