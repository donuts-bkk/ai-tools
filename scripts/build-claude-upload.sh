#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
plugin_dir="${repo_dir}/plugins/vibie-data-claude"
manifest="${plugin_dir}/.claude-plugin/plugin.json"
version=$(node -e 'const fs=require("fs"); const p=JSON.parse(fs.readFileSync(process.argv[1],"utf8")); process.stdout.write(p.version)' "$manifest")
output_dir="${repo_dir}/dist"
staging_dir="${output_dir}/.vibie-data-staging"
archive="${output_dir}/vibie-data-${version}.zip"

claude plugin validate "$plugin_dir"

rm -rf "$staging_dir"
mkdir -p "$staging_dir/.claude-plugin" "$staging_dir/skills/vibie-data" "$output_dir"
cp "$plugin_dir/.claude-plugin/plugin.json" "$staging_dir/.claude-plugin/plugin.json"
cp "$plugin_dir/.mcp.json" "$staging_dir/.mcp.json"
cp "$plugin_dir/skills/vibie-data/SKILL.md" "$staging_dir/skills/vibie-data/SKILL.md"

rm -f "$archive"
(
  cd "$staging_dir"
  zip -q -r "$archive" .
)
rm -rf "$staging_dir"

unzip -tq "$archive" >/dev/null
unzip -Z1 "$archive" | grep -qx '.claude-plugin/plugin.json'

printf 'Created %s\n' "$archive"
