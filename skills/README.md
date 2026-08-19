# Skills

Two locations:

- **`skills/`** — skills you write yourself (`SKILL.md` + optional scripts/references).
- **`.agents/skills/`** — third-party skills vendored with `npx skills add … --copy -y`, pinned in [`skills-lock.json`](../skills-lock.json).

`install.sh` symlinks both trees into user-level agent discovery paths. It never overwrites a name that already exists unless the existing link points into this kit.

Keep skills generic. Client-specific skills belong in that client's private overlay repo.

## Add a third-party skill

```bash
# Pin with owner/repo#ref so skills-lock.json records ref + computedHash.
# Prefer a tag. Use a branch only when the source repo has no tags.
npx skills add 'mattpocock/skills#v1.2.3' -s skill-name --copy -y
npx skills add 'cursor/plugins#main' -s skill-name --copy -y
git add .agents/skills skills-lock.json
```

Restore from the lockfile on a fresh clone:

```bash
npx skills experimental_install
./install.sh
```

## Add your own skill

Create `skills/your-skill-name/SKILL.md` with `name` and `description` frontmatter, then run `./install.sh`.
