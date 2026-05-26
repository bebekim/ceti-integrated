# CETI Integrated

Standalone monorepo for organizing Project CETI as an AI and data platform.

This repository preserves the history of existing Project CETI repositories under
`sources/`, while new project-level code lives in `packages/`, `pipelines/`,
`datasets/`, `experiments/`, and `docs/`.

## Current Imported Sources

The first source slice is imported with `git subtree`:

| Source | Path | Role |
| --- | --- | --- |
| WhAM | [`sources/wham/`](sources/wham/) | Transformer-based sperm whale coda generation, embeddings, and model evaluation |
| data-ingest | [`sources/data-ingest/`](sources/data-ingest/) | Field-device offload, local staging, and S3 upload tooling |
| sw-combinatoriality | [`sources/sw-combinatoriality/`](sources/sw-combinatoriality/) | Rhythm, tempo, rubato, ornamentation, and information-capacity analyses |

`sources/` is treated as imported upstream code. New integration code should wrap
these projects from `packages/`, `pipelines/`, and `experiments/` before any
source-level rewrite is considered.

## Repository Map

- [`docs/architecture/overview.md`](docs/architecture/overview.md): platform
  architecture and data-to-model flow.
- [`docs/glossary/core-terms.md`](docs/glossary/core-terms.md): shared CETI
  domain vocabulary.
- [`docs/data-contracts/initial-contracts.md`](docs/data-contracts/initial-contracts.md):
  starter dataset contracts for the first vertical slice.
- [`docs/papers/source-map.md`](docs/papers/source-map.md): paper/result areas
  mapped to imported source repositories.
- [`tools/source_repos.yaml`](tools/source_repos.yaml): source import manifest
  with upstream URLs, prefixes, and imported commits.

See
[`docs/superpowers/specs/2026-05-26-project-ceti-monorepo-design.md`](docs/superpowers/specs/2026-05-26-project-ceti-monorepo-design.md)
for the initial architecture design.
