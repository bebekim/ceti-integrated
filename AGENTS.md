# ceti-integrated Agent Instructions

This repository is currently a learning-oriented workspace for building the
Project CETI integrated monorepo.

## Issue Tracking

Do not use `bd` / beads for this repository at this stage. The parent
`AGENTS.md` beads integration does not apply inside `ceti-integrated` unless the
user explicitly re-enables it later.

- Do not run `bd init`, `bd ready`, `bd create`, `bd update`, `bd close`, or
  `bd dolt push`.
- Do not create a `.beads` workspace or add bead metadata.
- Track immediate work through the conversation and the repository changes
  themselves.

## Collaboration Style

The user is using this repository to learn. Explain important structural choices
briefly, especially when deciding where code, docs, schemas, or source imports
belong. Prefer concrete examples and file references over abstract process.

## Session Completion

For durable repository changes:

1. Run relevant quality checks for the files changed.
2. Commit intentionally.
3. Push the branch when a remote is configured.
4. Verify `git status --short --branch` shows a clean branch tracking its
   upstream.

Skip all beads-specific completion steps.
