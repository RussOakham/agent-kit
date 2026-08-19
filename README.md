# agent-kit

Public, tool-agnostic user-level skills and standing instructions for coding agents.

This repository is standalone. It does not install shell dotfiles, editor themes, or any client overlay. Client-specific composition belongs in a private repo in that client's org, which can clone this kit and run `install.sh` after their own toolkit.

## What you get

- `skills/` — skills you author
- `.agents/skills/` — vendored third-party skills (pinned in `skills-lock.json`)
- `AGENTS.md` — standing instructions ([AGENTS.md](https://agents.md) convention)
- `install.sh` — additive symlinks into user-level discovery paths

`install.sh` never overwrites a path it does not already own, never clones other git remotes, and never writes into a project working tree.

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

If `.agents/skills/` is missing after clone, restore from the lockfile then install:

```bash
cd ~/.local/share/agent-kit
npx skills experimental_install
./install.sh
```

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

## Add or update skills

See [`skills/README.md`](skills/README.md).

## Client overlays

This kit must stay free of client git URLs. For a company toolkit plus this kit plus your extras, use a private compositor repo whose `install.sh` runs theirs, then this `install.sh`, then links compositor-local skills.

## License

MIT
