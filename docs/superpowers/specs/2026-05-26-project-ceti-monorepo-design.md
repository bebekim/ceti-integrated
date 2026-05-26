# CETI Integrated Monorepo Design

Date: 2026-05-26
Status: Draft for user review

## Purpose

Create one standalone repository at `/Users/marcus.kim/repositories/individual/ceti-integrated` that presents Project CETI as a coherent AI and data platform for understanding sperm whale communication. The monorepo should preserve the history of the existing Project CETI repositories, keep future upstream pulls possible, and add a clean project-level architecture for data ingest, ETL, feature engineering, model training, evaluation, and reproducible scientific analysis.

The existing checkout at `/Users/marcus.kim/repositories/individual/project-ceti` is source material only. It is not the integrated monorepo root.

The monorepo should make the scientific and engineering flow legible:

```text
field devices and public datasets
  -> raw data ingest
  -> validated datasets
  -> acoustic and video processing
  -> coda, click, whale, event, and behavior features
  -> model training and evaluation
  -> scientific analyses and papers
```

## Design Decisions

1. Use one standalone git repository named `ceti-integrated`.
2. Preserve the git history of each imported repository.
3. Import existing repositories under `sources/`.
4. Treat `sources/` as preserved upstream research and application code.
5. Build new platform code outside `sources/`, primarily in `packages/`, `pipelines/`, `datasets/`, `experiments/`, and `docs/`.
6. Prefer `git subtree` for imports and ongoing upstream pulls.
7. Only modify imported `sources/*` code when the change is intended to be contributed back to the original upstream repository.

## Target Layout

```text
ceti-integrated/
  README.md
  docs/
    architecture/
    glossary/
    data-contracts/
    papers/
  sources/
    wham/
    data-ingest/
    whale-tag-embedded/
    sw-combinatoriality/
    coda-vowel-phonology/
    acoustics/
      pam-pipeline/
      click-presence-detector/
      localization/
      ship-noise-analysis/
      ship-noise-database/
    vision/
      segmentations-infrastructure/
      whale-birth-analysis/
    theory/
      theory-of-umt/
  packages/
    ceti-core/
    ceti-data/
    ceti-acoustics/
    ceti-vision/
    ceti-models/
  pipelines/
    ingest/
    etl/
    feature-builds/
    training/
    evaluation/
  datasets/
    manifests/
    schemas/
    splits/
  experiments/
    wham/
    combinatoriality/
    vowel-phonology/
    social-behavior/
  tools/
  tests/
```

## Source Repository Mapping

Existing Project CETI repositories should be imported into these paths:

| Source repo | Monorepo path | Role |
| --- | --- | --- |
| `wham` | `sources/wham/` | Whale acoustic modeling, synthetic codas, embeddings, downstream classification |
| `data-ingest` | `sources/data-ingest/` | Device offload, S3 upload, raw data ingestion |
| `whale-tag-embedded` | `sources/whale-tag-embedded/` | Embedded tag software and field device image build |
| `sw-combinatoriality` | `sources/sw-combinatoriality/` | Coda rhythm, tempo, rubato, ornamentation analysis |
| `coda-vowel-phonology` | `sources/coda-vowel-phonology/` | Spectral coda vowel data and analysis |
| `Complete_automated_PAM_pipelne` | `sources/acoustics/pam-pipeline/` | Passive acoustic monitoring pipeline |
| `Sperm_whale_click_presence_detector` | `sources/acoustics/click-presence-detector/` | Click presence detection |
| `Sperm_whale_localization` | `sources/acoustics/localization/` | Click-based localization |
| `Analysis-for-ship-noise` | `sources/acoustics/ship-noise-analysis/` | Ship noise analysis |
| `Database-for-ship-noise` | `sources/acoustics/ship-noise-database/` | Ship noise database artifacts |
| `segmentations_infrastructure` | `sources/vision/segmentations-infrastructure/` | Video segmentation parsing and interaction |
| `whale-birth-data-and-analysis-suite` | `sources/vision/whale-birth-analysis/` | Whale tracking, orientation, birth/social behavior analysis |
| `theory-of-umt` | `sources/theory/theory-of-umt/` | Theory of unsupervised translation for animal communication |

## Import And Sync Strategy

Use `git subtree` to import each existing repository into its target path.

Example initial import:

```bash
git subtree add \
  --prefix=sources/wham \
  https://github.com/Project-CETI/wham.git \
  main
```

Example upstream pull:

```bash
git subtree pull \
  --prefix=sources/wham \
  https://github.com/Project-CETI/wham.git \
  main
```

For repeated pulls, the monorepo should keep a manifest in `tools/source_repos.yaml` that records:

- source repository URL
- source branch
- monorepo prefix
- last imported upstream commit
- any local patches that have not been pushed upstream

The preferred workflow is:

1. Pull upstream changes into `sources/<repo>`.
2. Resolve conflicts inside the imported source path.
3. Keep project-level integration code outside `sources/`.
4. If a source-level fix is needed, make the smallest possible patch and contribute it back to the original repository.
5. After upstream accepts the patch, pull it back into the monorepo through the subtree path.

## Platform Layer Responsibilities

### `packages/ceti-core`

Shared types, configuration loading, path conventions, metadata models, project constants, logging setup, and small cross-cutting utilities. This package should stay compact and dependency-light.

### `packages/ceti-data`

Dataset contracts, schema validation, manifest readers, lineage metadata, split definitions, and quality checks. This package defines what a valid dataset means before acoustic, vision, or model code consumes it.

### `packages/ceti-acoustics`

Reusable APIs around acoustic processing concepts such as click detection, coda extraction, inter-click intervals, localization records, rhythm, tempo, rubato, ornamentation, and spectral vowel features. It can wrap algorithms imported under `sources/acoustics/*` without moving all original MATLAB or research code on day one.

### `packages/ceti-vision`

Reusable APIs around drone video metadata, segmentations, whale tracks, orientation, proximity, birth-event annotations, and social behavior features. It can wrap `sources/vision/*` while exposing stable interfaces for downstream feature builds.

### `packages/ceti-models`

Model interfaces, embedding APIs, training entry points, evaluation adapters, and model artifact metadata. WhAM should initially remain under `sources/wham`; project-level wrappers, evaluation harnesses, and reproducibility code should live here.

## Pipeline Layer Responsibilities

### `pipelines/ingest`

Workflows for moving field-device, mooring, drone, and public dataset files into a raw data zone with manifests and provenance.

### `pipelines/etl`

Workflows for converting raw data into validated, queryable, and reproducible intermediate datasets.

### `pipelines/feature-builds`

Workflows for producing acoustic features, visual behavior features, social context features, and joined multimodal feature tables.

### `pipelines/training`

Workflows for training and fine-tuning models such as WhAM-derived embeddings and downstream classifiers.

### `pipelines/evaluation`

Workflows for reproducible metrics, ablations, model comparisons, paper-table regeneration, and regression checks.

## Dataset Layer Responsibilities

`datasets/` should not hold large raw data. It should hold the definitions needed to find, validate, and reproduce datasets:

- `datasets/manifests/`: dataset inventory, storage URIs, checksums, licenses, provenance, and access notes
- `datasets/schemas/`: JSON Schema, Pandera, Pydantic, Arrow, or table contracts
- `datasets/splits/`: canonical train, validation, test, field season, whale, social unit, and paper-specific splits

Large data should remain in object storage, published archives, or external controlled-access locations.

## Experiments Layer Responsibilities

`experiments/` should contain reproducible configurations and thin orchestration for scientific results. It should not become the home of reusable library code.

Initial experiment areas:

- `experiments/wham/`: WhAM inference, embeddings, classifier evaluations, and generation metrics
- `experiments/combinatoriality/`: rhythm, tempo, rubato, ornamentation, and information-capacity reproductions
- `experiments/vowel-phonology/`: coda vowel spectral analyses and classification
- `experiments/social-behavior/`: drone/video-derived social behavior and network analyses

## Documentation Responsibilities

`docs/architecture/` should explain the project-level data and model architecture.

`docs/glossary/` should define shared domain language: click, coda, ICI, rhythm, tempo, rubato, ornamentation, vowel, whale identity, social unit, focal whale, tag, mooring, drone event, localization, and embedding.

`docs/data-contracts/` should describe each stable dataset contract in human-readable form.

`docs/papers/` should map papers to source repositories, datasets, experiments, and reproduction commands.

## Development Rules

1. New reusable Python code goes in `packages/`.
2. New orchestration goes in `pipelines/`.
3. New reproducibility configs go in `experiments/`.
4. Imported upstream code stays in `sources/`.
5. Do not move upstream source code into packages until a clear adapter boundary exists.
6. Avoid broad rewrites inside `sources/`; wrap first, upstream-patch second, migrate later.
7. Any new dataset shape must have a schema or manifest before model training depends on it.
8. Any model experiment should record input dataset version, code version, config, metrics, and output artifact location.

## Migration Phases

### Phase 1: Repository Formation

Create the empty monorepo structure, write the root README, import all existing repositories with `git subtree`, and record the source mapping in a machine-readable manifest.

### Phase 2: Architecture And Glossary

Add architecture docs, project glossary, paper-to-repo map, and data-flow diagrams. This makes the monorepo navigable before deep refactoring starts.

### Phase 3: Dataset Contracts

Define dataset manifests and schemas for raw acoustic data, coda tables, click tables, whale metadata, video segmentations, drone metadata, feature tables, and model-ready splits.

### Phase 4: Thin Wrappers

Create thin package APIs around the most important source components. The goal is stable project-level interfaces, not immediate rewrites.

### Phase 5: Reproducible Pipelines

Add ingest, ETL, feature-build, training, and evaluation workflows that call into packages and sources. Start with the smallest end-to-end path that reproduces a meaningful WhAM or coda-analysis result.

### Phase 6: Gradual Consolidation

When a source repo's logic becomes stable and repeatedly reused, extract it into `packages/` with tests. Keep original source history in `sources/` for provenance.

## Risks And Mitigations

| Risk | Mitigation |
| --- | --- |
| Monorepo becomes too large | Keep raw data out of git, use manifests, and avoid vendoring model weights |
| Subtree pulls become painful | Keep local edits to `sources/*` small and upstream-oriented |
| Research scripts stay hard to run | Wrap them with stable pipeline commands instead of rewriting immediately |
| Domain terms remain inconsistent | Establish `docs/glossary/` early and require new contracts to use glossary terms |
| Models train on unclear data versions | Require dataset manifests, split files, and run metadata for every training pipeline |
| Imported repos use incompatible environments | Keep source envs intact initially, then introduce package-level adapters and shared tooling gradually |

## Acceptance Criteria

The monorepo design is successful when:

1. All existing Project CETI repositories are imported under stable `sources/` paths with history preserved.
2. A contributor can understand the whole project flow from the root README and architecture docs.
3. Upstream changes can be pulled into at least one imported repo using a documented subtree command.
4. New platform code has clear homes in `packages/`, `pipelines/`, `datasets/`, and `experiments/`.
5. The first reproducible end-to-end workflow can run without needing to understand every imported source repo.
6. The project clearly separates acoustic data processing, video/social behavior processing, dataset contracts, model training, and scientific analysis.

## Recommended First Implementation Plan

1. Create the root monorepo scaffolding.
2. Add `tools/source_repos.yaml` with source URL, branch, and prefix for each import.
3. Import `wham`, `data-ingest`, and `sw-combinatoriality` first as a representative vertical slice.
4. Add root documentation that explains the data-to-model flow.
5. Add initial dataset contract stubs for codas, clicks, whales, and WhAM-ready audio examples.
6. Add one wrapper or pipeline that proves the monorepo can call into an imported source repo without modifying it.

