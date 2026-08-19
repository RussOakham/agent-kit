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
