# Skills

Two locations:

- **`skills/`** — skills you write yourself (`SKILL.md` + optional scripts/references).
- **`.agents/skills/`** — third-party skills vendored with `npx skills add … --copy -y`, pinned in [`skills-lock.json`](../skills-lock.json).

`install.sh` symlinks both trees into user-level agent discovery paths. It never overwrites a name that already exists unless the existing link points into this kit.

Keep skills generic and portable. Organisation- or project-specific skills belong in a compositor repo or the target project's own tree.
