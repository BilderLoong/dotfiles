#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
script_path="${script_dir}/copy-skills-to-codex"
tmp_dir=$(mktemp -d)

cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT HUP INT TERM

repo_skills="${tmp_dir}/repo/agents/.agents/skills"
target_skills="${tmp_dir}/home/.agents/skills"
old_target="${tmp_dir}/old-target"

mkdir -p "${repo_skills}/alpha/agents" "${repo_skills}/not-a-skill" "${target_skills}/alpha" "${target_skills}/beta" "$old_target"

printf '%s\n' 'name: old-alpha' > "${old_target}/SKILL.md"
ln -s "${old_target}/SKILL.md" "${target_skills}/alpha/SKILL.md"
printf '%s\n' 'name: beta' > "${target_skills}/beta/SKILL.md"

cat > "${repo_skills}/alpha/SKILL.md" <<'SKILL'
---
name: alpha
description: Test skill.
---

# Alpha
SKILL
printf '%s\n' 'interface:' '  display_name: "Alpha"' > "${repo_skills}/alpha/agents/openai.yaml"
printf '%s\n' 'ignore me' > "${repo_skills}/not-a-skill/README.md"

"$script_path" "$repo_skills" "$target_skills"

test -f "${target_skills}/alpha/SKILL.md"
test ! -L "${target_skills}/alpha/SKILL.md"
cmp "${repo_skills}/alpha/SKILL.md" "${target_skills}/alpha/SKILL.md"
test -f "${target_skills}/alpha/agents/openai.yaml"
test ! -L "${target_skills}/alpha/agents/openai.yaml"
test -f "${target_skills}/beta/SKILL.md"
test ! -e "${target_skills}/not-a-skill"
