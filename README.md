# Donuts Bangkok AI Tools

Public Git marketplace for AI tools maintained by Donuts Bangkok. One marketplace can distribute
multiple project-specific plugins while each project's data, credentials, OAuth policy, and server
remain isolated.

The marketplace currently offers **Vibie Data** and **Dev Tools** (see below). Vibie Data is backed by the OAuth-protected, read-only MCP endpoint at
`https://mcp.vibie.live/mcp`. This repository contains only client manifests, MCP endpoint metadata,
and business-language skills. It contains no database credentials, native binary, private backend
source, Auth0 client secret, or operational secret.

The reusable MCP server core and private operations documents live in the private repository
`github.com/donuts-bkk/data-mcp`.

## Current client status

| Client | Recommended path | Status |
| --- | --- | --- |
| Codex | Add this Git marketplace and install the project plugin | Package and marketplace are available; verify OAuth and tool invocation after every release |
| Claude Code | Add this Git marketplace and install `vibie-data@ai-tools` | Package is available; record a fresh end-to-end result before announcing a release |
| Claude Desktop | Add `https://mcp.vibie.live/mcp` as a custom connector | Tested successfully |
| ChatGPT Desktop | Repository-installed plugin | **Pending:** team installation can complete Google sign-in but the MCP tools may not become available in a new chat |
| ChatGPT web | Bundled `.mcp.json` | Not supported by this distribution path |

Do not claim ChatGPT team support until the pending connector-loading issue is resolved and tested
on a second account. The previous `.app.json` experiment depended on an account-scoped Development
app and caused other users to see **Couldn't load connector**; it was removed. Do not restore it
unless the app has a shared publication/access model that all intended users can use.

## Install in Codex

Each team member adds the public marketplace once. Run in macOS Terminal or Windows PowerShell:

```bash
codex plugin marketplace add https://github.com/donuts-bkk/ai-tools.git
```

No GitHub account or SSH key is required. Then:

1. Restart Codex.
2. Open **Settings -> Plugins**.
3. Choose **Vibie Team -> Vibie Data** and click **Install**.
4. Complete Auth0 login with an authorized, verified `@donuts-bkk.com` Google Workspace account.
5. Start a new task and ask a Vibie business-data question.

The Codex package uses `plugins/vibie-data/.mcp.json` with the hosted MCP URL and
`oauth_resource`. The MCP broker performs DCR/PKCE and delegates company login to the central Auth0
application; installing the plugin does not create a new Auth0 Application.

CLI smoke test:

```bash
codex plugin add vibie-data@personal
codex mcp logout vibie-data
codex mcp login vibie-data --oauth-client-registration dcr
```

`personal` is the current technical marketplace identifier; the GUI display name is **Vibie Team**.

## Install in Claude Code

Inside Claude Code:

```text
/plugin marketplace add https://github.com/donuts-bkk/ai-tools.git
/plugin install vibie-data@ai-tools
/reload-plugins
```

Then run `/mcp`, select Vibie Data, and authenticate with an authorized, verified company account.
The equivalent terminal commands are:

```bash
claude plugin marketplace add https://github.com/donuts-bkk/ai-tools.git
claude plugin install vibie-data@ai-tools
```

Update an existing installation with:

```text
/plugin marketplace update ai-tools
/plugin update vibie-data@ai-tools
/reload-plugins
```

Claude Code uses the semantic version in `plugins/vibie-data-claude/.claude-plugin/plugin.json`.
Maintainers must bump it for every Claude-facing package change.

## Use in Claude Desktop

Claude Desktop can connect directly without installing the Git marketplace:

1. Open **Settings -> Connectors -> Add custom connector**.
2. Enter `Vibie Data` and `https://mcp.vibie.live/mcp`.
3. Choose **Always required** for Authentication.
4. Choose **Use your own OAuth client** and enter the centrally managed client details supplied by
   the system owner according to the private Auth0 runbook.
5. Connect, finish company Google sign-in, and enable the Vibie Data tools in a new conversation.

The current tested Claude Desktop path uses the managed client. Broker DCR remains stateless and
does not create Auth0 Applications; Auth0 tenant DCR remains disabled. The authoritative client
details and secret-handling procedure are private and must not be copied into this public repository.

## Dev Tools (Claude Code only)

`dev-tools` is the shared plugin for engineering skills and subagents. Engineers install it once;
new skills added to it arrive with `/plugin update`, with no new install.

```text
/plugin marketplace add https://github.com/donuts-bkk/ai-tools.git
/plugin install dev-tools@ai-tools
/reload-plugins
```

Update to get new or changed skills:

```text
/plugin marketplace update ai-tools
/plugin update dev-tools@ai-tools
/reload-plugins
```

### Skills

| Command | What it does |
| --- | --- |
| `/dev-tools:review-until-clean` | Reviews the current uncommitted change with the read-only `diff-reviewer` subagent, fixes Critical and High findings, and re-reviews until PASS or five reviews. Progress and reports are in Thai. |

`review-until-clean` notes:

- Run it from the repository you will commit from, with the change still uncommitted.
- The skill only runs when typed; Claude never starts it on its own.
- The subagent uses the `opus` alias (latest Opus available to the account) at high effort, so the
  account must have Opus access. Set `ANTHROPIC_DEFAULT_OPUS_MODEL` to pin a specific version.
- It uses `/engineering:code-review` when the `engineering` plugin is enabled and otherwise
  falls back to its built-in review checklist.
- If you already have a personal copy in `~/.claude/skills` and `~/.claude/agents`, remove it to
  avoid two versions drifting apart.

### Add a skill to Dev Tools

1. Add `plugins/dev-tools/skills/<skill-name>/SKILL.md`, plus any subagent it needs in
   `plugins/dev-tools/agents/<agent-name>.md`.
2. Refer to bundled subagents by their namespaced name, `dev-tools:<agent-name>`.
3. Add a row to the Skills table above.
4. Bump `version` in `plugins/dev-tools/.claude-plugin/plugin.json`; Claude Code only offers
   updates when the version changes.
5. Run `claude plugin validate plugins/dev-tools` and `claude plugin validate .`, then test the
   skill from a fresh install before announcing it.

Keep this plugin free of secrets and project-specific data; it is published in a public repository.

## Update an existing Codex installation

```bash
codex plugin marketplace upgrade personal
```

Restart Codex, open **Settings -> Plugins -> Vibie Team -> Vibie Data**, use the update action if
shown, and start a new task. Verify the configured source with:

```bash
codex plugin marketplace list
```

## Add another project

Use one marketplace entry per project so users install only the tools they are authorized to use.
For a new project `<slug>`:

1. In the private `data-mcp` repository, create and review `profiles/<slug>.json` from the real
   schema and business definitions.
2. Deploy a separate MCP instance with its own hostname, read-only DB role, database secret, OAuth
   resource/scope, broker secret, logs, and health checks.
3. Add `plugins/<slug>-data` for Codex and `plugins/<slug>-data-claude` for Claude.
4. Add entries to `.agents/plugins/marketplace.json` and `.claude-plugin/marketplace.json`.
5. Keep both skills semantically aligned, but keep their client-specific MCP manifests separate.
6. Validate the packages and complete OAuth plus real-tool end-to-end tests before publishing.

Never point two projects at the same DB identity or copy private schemas, runbooks, credentials, or
secrets into this public repository. Full project onboarding and the AI-agent handoff prompt are in
`docs/NEW-PROJECT.md` in the private `data-mcp` repository.

## Maintainer workflow

1. Change the private MCP core/profile first when server behavior or business definitions change.
2. Update the matching Codex and Claude packages and keep their skill instructions aligned.
3. Bump the Codex cachebuster/version for Codex-facing package changes and the Claude semantic
   version for Claude-facing changes. Documentation-only changes do not require a package bump.
4. Validate both package directories and both marketplace manifests.
5. Commit and push to `https://github.com/donuts-bkk/ai-tools`.
6. Test with a fresh client/account before announcing team availability.

Codex and Claude use separate package directories because their remote MCP OAuth manifest schemas
differ. These Git marketplaces are separate from the OpenAI and Anthropic public directories; the
direct Git distribution workflow does not itself require directory review.

## Security boundary

- Public: plugin manifests, MCP URLs, non-secret scopes, and business-language guidance.
- Private: MCP implementation, database/schema details, Auth0 operations, deployment configuration,
  audit procedures, and all secrets.
- Runtime: OAuth verifies the company identity; the MCP server independently enforces read-only SQL,
  bounded results, project timezone, sensitive-field restrictions, and audit logging.
- Client machines never receive a database credential.

The production Auth0 inventory, change procedure, incident response, and rollback checklist are
maintained privately in `github.com/donuts-bkk/data-mcp/docs/AUTH0-RUNBOOK.md`.
