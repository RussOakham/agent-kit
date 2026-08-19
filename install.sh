#!/usr/bin/env bash
# Additive user-level installer. Never clones other repos.
# Never overwrites unmanaged files. Never writes into a project working tree.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Author your own under skills/; third-party copies live in .agents/skills/ (see skills-lock.json).
SKILL_SOURCES=(
  "${ROOT}/skills"
  "${ROOT}/.agents/skills"
)
AGENTS_SRC="${ROOT}/AGENTS.md"

SKILL_ROOTS=(
  "${HOME}/.agents/skills"
  "${HOME}/.claude/skills"
  "${HOME}/.cursor/skills"
  "${HOME}/.codex/skills"
  "${HOME}/.kiro/skills"
  "${HOME}/.grok/skills"
)

AGENTS_TARGETS=(
  "${HOME}/.agents/AGENTS.md"
  "${HOME}/.kiro/steering/AGENTS.md"
  "${HOME}/.grok/AGENTS.md"
  "${HOME}/.claude/CLAUDE.md"
)

log() {
  printf '%s\n' "$*"
}

realpath_portable() {
  python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "$1"
}

# True when dest is a symlink into this kit (safe to refresh).
is_kit_link() {
  local dest="$1"
  [[ -L "$dest" ]] || return 1
  local target
  target="$(realpath_portable "$dest")"
  local root_real
  root_real="$(realpath_portable "$ROOT")"
  [[ "$target" == "$root_real" || "$target" == "$root_real"/* ]]
}

# Link src -> dest. Skip if dest exists and is not already ours.
link_additive() {
  local src="$1"
  local dest="$2"
  local dest_dir
  dest_dir="$(dirname "$dest")"
  mkdir -p "$dest_dir"

  if [[ -L "$dest" ]] && is_kit_link "$dest"; then
    ln -sfn "$src" "$dest"
    log "refresh  ${dest}"
    return 0
  fi

  if [[ -e "$dest" || -L "$dest" ]]; then
    log "skip     ${dest} (already exists)"
    return 0
  fi

  ln -s "$src" "$dest"
  log "link     ${dest}"
}

install_skills_from_dir() {
  local skills_src="$1"
  local skill_dir name dest_root
  [[ -d "$skills_src" ]] || return 0
  shopt -s nullglob
  for skill_dir in "${skills_src}"/*/; do
    [[ -f "${skill_dir}SKILL.md" ]] || continue
    name="$(basename "$skill_dir")"
    for dest_root in "${SKILL_ROOTS[@]}"; do
      link_additive "${skill_dir%/}" "${dest_root}/${name}"
    done
  done
  shopt -u nullglob
}

install_skills() {
  local skills_src
  for skills_src in "${SKILL_SOURCES[@]}"; do
    install_skills_from_dir "$skills_src"
  done
}

install_agents_md() {
  local dest
  [[ -f "$AGENTS_SRC" ]] || return 0
  for dest in "${AGENTS_TARGETS[@]}"; do
    link_additive "$AGENTS_SRC" "$dest"
  done
}

in_gitpod() {
  [[ -n "${GITPOD_WORKSPACE_ID:-}" || -n "${GITPOD_REPO_ROOT:-}" ]]
}

install_catalog() {
  local catalog="${ROOT}/catalog.json"
  [[ -f "$catalog" ]] || return 0

  if in_gitpod && [[ "${INSTALL_THIRD_PARTY:-}" != "1" ]]; then
    log "skip     catalog.json (Gitpod; set INSTALL_THIRD_PARTY=1 to enable)"
    return 0
  fi

  if [[ "${INSTALL_THIRD_PARTY:-}" != "1" ]]; then
    log "skip     catalog.json (set INSTALL_THIRD_PARTY=1 to enable)"
    return 0
  fi

  if ! command -v npx >/dev/null 2>&1; then
    log "skip     catalog.json (npx not found)"
    return 0
  fi

  python3 - "$catalog" <<'PY' | while IFS= read -r pkg; do
import json, sys
data = json.load(open(sys.argv[1], encoding="utf-8"))
for item in data.get("packages") or []:
    if isinstance(item, str) and item.strip():
        print(item.strip())
    elif isinstance(item, dict) and item.get("package"):
        print(item["package"])
PY
    [[ -n "$pkg" ]] || continue
    log "catalog  npx skills add ${pkg} -g -y"
    npx --yes skills add "$pkg" -g -y
  done
}

main() {
  log "agent-kit ${ROOT}"
  install_skills
  install_agents_md
  install_catalog
  log "done"
}

main "$@"
