# agent-kit

Standalone user-level dotfiles for coding agents: portable skills, standing instructions, and an additive installer. Use as-is on any machine, or combine with other dotfile repos through a compositor.

This repo does **not** install shell dotfiles, editor themes, or project-level config. `install.sh` only creates symlinks under your home directory and never writes into a project working tree.

## What you get

| Path | Purpose |
|------|---------|
| `skills/` | [Agent Skills](https://agentskills.io) packages (`SKILL.md` per directory) |
| `AGENTS.md` | User-level standing instructions ([AGENTS.md](https://agents.md) convention) |
| `workflows/` | Optional long-form notes that skills can reference |
| `adapters/` | Tool-specific formats when a skill cannot be fully portable |
| `install.sh` | Additive symlinks into user-level agent discovery paths |
| `catalog.json` | Optional third-party skills (`npx skills add`); off by default |

`install.sh` never overwrites a path it does not already own and never clones other git remotes.

## Bundled skills

| Skill | Source | Pin |
| --- | --- | --- |
| ask-matt | [mattpocock/skills](https://github.com/mattpocock/skills) | tag `v1.2.3` |
| code-review | mattpocock/skills | tag `v1.2.3` |
| diagnosing-bugs | mattpocock/skills | tag `v1.2.3` |
| grill-me | mattpocock/skills | tag `v1.2.3` |
| handoff | mattpocock/skills | tag `v1.2.3` |
| resolving-merge-conflicts | mattpocock/skills | tag `v1.2.3` |
| tdd | mattpocock/skills | tag `v1.2.3` |
| writing-for-agents | mattpocock/skills | tag `v1.2.3` |
| blast-radius | [cursor/plugins](https://github.com/cursor/plugins) (pstack) | branch `main` |
| unslop | cursor/plugins (pstack) | branch `main` |

[`skills-lock.json`](skills-lock.json) records `ref` (tag, branch, or commit) plus `computedHash`. Restore with `npx skills experimental_install`. `cursor/plugins` has no tags, so those two skills pin to `main`.

## Install

Clone once, then run the installer:

```bash
git clone https://github.com/RussOakham/agent-kit.git ~/.local/share/agent-kit
~/.local/share/agent-kit/install.sh
```

Update after pulling:

```bash
git -C ~/.local/share/agent-kit pull --ff-only
~/.local/share/agent-kit/install.sh
```

On Windows, run this inside WSL `$HOME` if that is where you code.

### Optional third-party catalog

```bash
cd ~/.local/share/agent-kit
npx skills experimental_install
./install.sh
```

On Gitpod, catalog install stays off unless `INSTALL_THIRD_PARTY=1` is set, so the dotfiles timeout is not spent on `npx`.

## Where files land

Each skill directory with a `SKILL.md` is linked (when the name is free) into:

- `~/.agents/skills/`
- `~/.claude/skills/`
- `~/.cursor/skills/`
- `~/.codex/skills/`
- `~/.kiro/skills/`
- `~/.grok/skills/`

`AGENTS.md` is linked (when the target is free) into **user-level** paths only:

- `~/.agents/AGENTS.md`
- `~/.kiro/steering/AGENTS.md`
- `~/.grok/AGENTS.md`
- `~/.claude/CLAUDE.md`

It is **not** linked into project repos. If you need project-specific instructions, add an `AGENTS.md` (or tool equivalent) in that repo separately.

### IDE and agent coverage

| Tool / environment | Skills | Standing instructions |
|--------------------|--------|------------------------|
| Cursor | `~/.cursor/skills/` | Project `AGENTS.md` / rules (not installed by this kit) |
| Claude Code / Claude desktop | `~/.claude/skills/`, `~/.claude/CLAUDE.md` | `CLAUDE.md` symlink |
| Codex | `~/.codex/skills/` | — |
| Kiro | `~/.kiro/skills/`, `~/.kiro/steering/AGENTS.md` | `AGENTS.md` symlink |
| Grok | `~/.grok/skills/`, `~/.grok/AGENTS.md` | `AGENTS.md` symlink |
| agents.dev convention | `~/.agents/skills/`, `~/.agents/AGENTS.md` | `AGENTS.md` symlink |

### Cloud and remote environments

**Cursor Cloud Agents** — Add to your [environment](https://cursor.com/docs/cloud-agent) install script:

```bash
git clone https://github.com/RussOakham/agent-kit.git ~/.local/share/agent-kit
~/.local/share/agent-kit/install.sh
```

**Gitpod** — Reference in `.gitpod.yml` dotfiles, or clone in an `onCreateCommand` / custom Docker image. Catalog install is skipped by default (see above).

**GitHub Codespaces / Dev Containers** — Run the same clone + `install.sh` in `postCreateCommand` or your Dockerfile `RUN` step so skills and instructions exist in the container user's `$HOME`.

**CI / headless** — Safe to run in any job that has `$HOME`; the installer is non-destructive and idempotent.

## AGENTS.md — keep or skip?

**Keep it** if you want the same standing instructions on every machine (working style, verification, git habits). The file is written to apply in **whatever repo the agent is working in** — it does not mention this dotfiles repo.

**Skip linking it** by removing or renaming `AGENTS.md` in your fork, or by not running `install_agents_md` in a compositor that omits this step. Skills work independently of `AGENTS.md`.

Do **not** symlink this kit's `AGENTS.md` into individual project repos unless you intentionally want these global instructions to appear as project context (usually prefer a project-local file instead).

## Compositor repo pattern

When you need **this kit + another dotfile repo + your own extras**, use a private **compositor** repo that orchestrates install order. Each source stays standalone; the compositor only runs their installers and adds its own links.

```
your-compositor/
├── install.sh          # runs child installers in order
├── skills/             # your personal or org-specific skills
└── README.md
```

Example `install.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

# 1. Another dotfiles repo (shell, editor, etc.)
/path/to/other-dotfiles/install.sh

# 2. This kit (skills + user-level AGENTS.md)
~/.local/share/agent-kit/install.sh

# 3. Compositor-local skills (same layout as agent-kit/skills/)
COMPOSITOR_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Re-use link_additive pattern or call a small helper that symlinks
# COMPOSITOR_ROOT/skills/* into the same SKILL_ROOTS as install.sh
```

Rules of thumb:

- Run **specialised repos first**, then **agent-kit**, then **compositor-local** overlays so more specific skills can occupy a name first (agent-kit skips existing names).
- Keep compositor-only content in the compositor; keep agent-kit generic and public.
- Pin versions (git tags or submodules) if you need reproducible cloud images.

## Add a skill

See [`skills/README.md`](skills/README.md).

See `skills/README.md` for layout and `workflows/README.md` for optional supporting docs.

## License

MIT
