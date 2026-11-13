# CETI Integrated

Standalone monorepo for organizing Project CETI as an AI and data platform.

This repository preserves the history of existing Project CETI repositories under
`sources/`, while new project-level code lives in `packages/`, `pipelines/`,
`datasets/`, `experiments/`, and `docs/`.

## Imported Sources

Project CETI source repositories are imported with `git subtree`:

| Source | Path | Role |
| --- | --- | --- |
| WhAM | [`sources/wham/`](sources/wham/) | Transformer-based sperm whale coda generation, embeddings, and model evaluation |
| data-ingest | [`sources/data-ingest/`](sources/data-ingest/) | Field-device offload, local staging, and S3 upload tooling |
| whale-tag-embedded | [`sources/whale-tag-embedded/`](sources/whale-tag-embedded/) | Embedded tag data-capture and deployment tooling |
| sw-combinatoriality | [`sources/sw-combinatoriality/`](sources/sw-combinatoriality/) | Rhythm, tempo, rubato, ornamentation, and information-capacity analyses |
| coda-vowel-phonology | [`sources/coda-vowel-phonology/`](sources/coda-vowel-phonology/) | Coda vowel and phonology analysis |
| Complete_automated_PAM_pipelne | [`sources/acoustics/pam-pipeline/`](sources/acoustics/pam-pipeline/) | Automated passive acoustic monitoring pipeline components |
| Sperm_whale_click_presence_detector | [`sources/acoustics/click-presence-detector/`](sources/acoustics/click-presence-detector/) | Sperm whale click presence detection |
| Sperm_whale_localization | [`sources/acoustics/localization/`](sources/acoustics/localization/) | Sperm whale acoustic localization experiments and utilities |
| Analysis-for-ship-noise | [`sources/acoustics/ship-noise-analysis/`](sources/acoustics/ship-noise-analysis/) | Ship-noise analysis notebooks and scripts |
| Database-for-ship-noise | [`sources/acoustics/ship-noise-database/`](sources/acoustics/ship-noise-database/) | Ship-noise database materials |
| segmentations_infrastructure | [`sources/vision/segmentations-infrastructure/`](sources/vision/segmentations-infrastructure/) | Video segmentation infrastructure and helpers |
| whale-birth-data-and-analysis-suite | [`sources/vision/whale-birth-analysis/`](sources/vision/whale-birth-analysis/) | Whale birth data and analysis workflows |
| theory-of-umt | [`sources/theory/theory-of-umt/`](sources/theory/theory-of-umt/) | Theory of UMT simulations and sweeps |
| avatars-code | [`sources/robotics/avatars-code/`](sources/robotics/avatars-code/) | RL-based autonomous whale rendezvous via VHF/AOA sensing (Science Robotics 2024) |
| avatars-data | [`sources/robotics/avatars-data/`](sources/robotics/avatars-data/) | AVATARS field datasets (acoustic + VHF + GPS) |
| Glider_Backseat_Driver | [`sources/robotics/glider-backseat-driver/`](sources/robotics/glider-backseat-driver/) | Seaglider field-experiment telemetry (France, cross-population data) |
| Predicting-Mesoscale-Movements-... | [`sources/behavior/mesoscale-movements/`](sources/behavior/mesoscale-movements/) | Social-dynamics-driven sperm whale unit movement data |

`sources/` is treated as imported upstream code. New integration code should wrap
these projects from `packages/`, `pipelines/`, and `experiments/` before any
source-level rewrite is considered.

## Repository Map

- [`docs/PROJECTS.md`](docs/PROJECTS.md): plain-language guide to the 17
  imported projects and how they fit together.
- [`docs/architecture/overview.md`](docs/architecture/overview.md): platform
  architecture and data-to-model flow.
- [`docs/architecture/source-import-workflow.md`](docs/architecture/source-import-workflow.md):
  subtree pull commands and manifest update rules for imported sources.
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
