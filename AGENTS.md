# Agent instructions

Personal, tool-agnostic standing instructions. Applies across editors and coding agents. Keep this file short. Put specialised workflows in `skills/`.

## Working style

- Prefer small, reviewable changes over large mixed diffs.
- Match the repository you are in: existing patterns, test commands, and review process win over generic advice.
- Do not invent client, employer, or product names. Do not write secrets, tokens, or credentials.

## Before changing code

- Read enough surrounding code to match style and architecture.
- Prefer existing libraries and scripts in the repo over adding new tooling.
- If the task is ambiguous, ask rather than guessing at product behaviour.

## Verification

- Run the project's own lint, typecheck, and tests when they exist.
- Do not claim tests passed unless you ran them.
- Leave the tree in a state the user can commit: no leftover debug, no unrelated files.

## Git and reviews

- Only commit or push when the user asks.
- Do not rewrite published history.
- Pull-request descriptions should explain why, not restated diffs.

## Scope

- User-level only. Do not add `AGENTS.md`, `CLAUDE.md`, or editor rules to a repository unless the user asks.
- Client-specific skills and overlay installers live in private per-client repos, not here.

## Cursor Cloud specific instructions

This repo is content, not an application: markdown skills (`skills/`, vendored `.agents/skills/` pinned by `skills-lock.json`), standing instructions (`AGENTS.md`), and one Bash entrypoint (`install.sh`). There is nothing to compile or serve.

- Dependencies: none. `node`, `npm`/`npx`, `python3`, and `bash` are preinstalled in the base image; the repo has no `package.json`, lockfile (in the language sense), or virtualenv, so the startup update script is a no-op.
- Run / "build": `./install.sh` from the repo root. It additively symlinks every skill dir and `AGENTS.md` into user discovery paths (`~/.agents`, `~/.claude`, `~/.cursor`, `~/.codex`, `~/.kiro`, `~/.grok`). It is idempotent (re-running refreshes kit-owned links) and never overwrites a path it does not own (foreign files are skipped), so it is safe to re-run. It writes into `$HOME`, not the repo tree.
- Lint / test / build / CI: none are defined in the repo. The closest to a lint is a Bash syntax check: `bash -n install.sh`. Do not claim a lint/test suite exists.
- Optional vendored-skill restore: `npx skills experimental_install` (reads `skills-lock.json`; needs network). The `skills` CLI wants Node `>=22.20`; the base image Node is slightly older, which only emits an `EBADENGINE` warning.
- `INSTALL_THIRD_PARTY=1 ./install.sh` only does extra work when a `catalog.json` exists; there is none in this repo, so it is otherwise a no-op branch.
