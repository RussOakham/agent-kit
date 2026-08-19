# Skills

Add one directory per skill. Each directory must contain a `SKILL.md` with Agent Skills frontmatter (`name`, `description`). See https://agentskills.io

`install.sh` symlinks each top-level skill folder into user-level discovery paths. It never overwrites a name that already exists and is not already a link into this kit.

Keep skills generic. Client-specific skills belong in that client's private overlay repo.
