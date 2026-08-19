# agent-kit

Public, tool-agnostic user-level skills and standing instructions for coding agents.

This repository is standalone. It does not install shell dotfiles, editor themes, or any client overlay. Client-specific composition belongs in a private repo in that client's org, which can clone this kit and run `install.sh` after their own toolkit.

## What you get

- `skills/` — [Agent Skills](https://agentskills.io) (`SKILL.md` packages)
- `AGENTS.md` — standing instructions ([AGENTS.md](https://agents.md) convention)
- `install.sh` — additive symlinks into user-level discovery paths
- `catalog.json` — optional third-party skills (`npx skills add`), off by default

`install.sh` never overwrites a path it does not already own, never clones other git remotes, and never writes into a project working tree.

## Install

```bash
git clone https://github.com/RussOakham/agent-kit.git ~/.local/share/agent-kit
~/.local/share/agent-kit/install.sh
```

Update:

```bash
git -C ~/.local/share/agent-kit pull --ff-only
~/.local/share/agent-kit/install.sh
```

On Windows, run this inside WSL `$HOME` if that is where you code.

Optional third-party catalog:

```bash
INSTALL_THIRD_PARTY=1 ~/.local/share/agent-kit/install.sh
```

On Gitpod, catalog install stays off unless `INSTALL_THIRD_PARTY=1` is set, so the 120s dotfiles timeout is not spent on `npx`.

## Where files land

Each skill directory with a `SKILL.md` is linked (when the name is free) into:

- `~/.agents/skills/`
- `~/.claude/skills/`
- `~/.cursor/skills/`
- `~/.codex/skills/`
- `~/.kiro/skills/`
- `~/.grok/skills/`

`AGENTS.md` is linked (when the name is free) into:

- `~/.agents/AGENTS.md`
- `~/.kiro/steering/AGENTS.md`
- `~/.grok/AGENTS.md`
- `~/.claude/CLAUDE.md`

## Add a skill

Create `skills/your-skill-name/SKILL.md` with `name` and `description` frontmatter. Re-run `install.sh`.

## Client overlays

This kit must stay free of client git URLs. For a company toolkit plus this kit plus your extras, use a private compositor repo whose `install.sh` runs theirs, then this `install.sh`, then links compositor-local skills.

## License

MIT
