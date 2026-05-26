# CETI Integrated Architecture Overview

## Purpose

`ceti-integrated` is the project-level home for turning Project CETI research
repositories into a coherent AI and data platform. It keeps upstream repository
history intact under `sources/` and puts new integration code, contracts, and
reproducible workflows outside those imported trees.

## First Vertical Slice

The first imported slice covers the path from field data movement to acoustic
structure analysis and model evaluation:

```text
field devices and public datasets
  -> sources/data-ingest
  -> datasets/manifests and datasets/schemas
  -> packages/ceti-data and packages/ceti-acoustics
  -> sources/sw-combinatoriality analyses
  -> packages/ceti-models and sources/wham
  -> pipelines/evaluation and experiments/wham
```

This is intentionally thin. Imported repositories remain runnable on their own,
while platform packages and pipelines will grow stable wrappers around the
parts that become reused across papers and models.

## Imported Source Responsibilities

### `sources/data-ingest`

Owns field-device offload and upload mechanics. It includes the `ceti` CLI for
whale tag discovery/offload, generic non-tag offload, local staging, backup,
compression, and S3 upload.

Platform boundary:

- `pipelines/ingest` should call this tooling or wrap it with run metadata.
- `datasets/manifests` should describe the files produced or uploaded.
- `packages/ceti-data` should validate manifests after files land in storage.

### `sources/sw-combinatoriality`

Owns the published combinatoriality analysis notebooks and data artifacts for
rhythm, tempo, rubato, ornamentation, and information capacity.

Platform boundary:

- `packages/ceti-acoustics` should expose reusable coda feature types.
- `experiments/combinatoriality` should hold reproducible configs for paper
  regeneration.
- `datasets/schemas/codas.schema.json` should define the coda records consumed
  by reusable code.

### `sources/wham`

Owns WhAM model code, inherited VampNet components, generation scripts,
embedding workflows, downstream classification, and generative metrics.

Platform boundary:

- `packages/ceti-models` should expose stable inference, embedding, training,
  and evaluation interfaces.
- `experiments/wham` should hold model and dataset configurations.
- `datasets/schemas/wham_audio_examples.schema.json` should define model-ready
  audio examples before training or evaluation pipelines depend on them.

## New Platform Responsibilities

### `packages/`

Reusable Python APIs. These packages should be small, dependency-aware wrappers
around stable concepts:

- `ceti-core`: paths, configuration, run metadata, logging, project constants.
- `ceti-data`: manifest readers, schema validation, lineage, dataset splits.
- `ceti-acoustics`: clicks, codas, inter-click intervals, rhythm, tempo, rubato,
  ornamentation, and spectral features.
- `ceti-vision`: drone metadata, segmentations, tracks, orientation, proximity,
  and social behavior features.
- `ceti-models`: model adapters, embedding APIs, evaluation harnesses, artifact
  metadata.

### `pipelines/`

Thin orchestration for reproducible work:

- `ingest`: raw field-device and public dataset intake.
- `etl`: raw-to-validated dataset conversion.
- `feature-builds`: acoustic, visual, social, and multimodal feature tables.
- `training`: model training and fine-tuning.
- `evaluation`: metrics, ablations, paper tables, and regression checks.

### `datasets/`

No large raw data. This area records how data is found, checked, split, and
reproduced:

- `manifests`: inventory, storage URIs, checksums, licenses, provenance.
- `schemas`: machine-readable table or record contracts.
- `splits`: canonical train, validation, test, whale, social-unit, field-season,
  and paper-specific split definitions.

### `experiments/`

Reproducible scientific runs and thin orchestration. Reusable logic belongs in
`packages/`; experiment directories should mostly contain configs, run scripts,
and result-regeneration notes.

## Source Import Workflow

Initial imports use `git subtree` without squash so upstream history remains in
the integrated repository:

```bash
git subtree add --prefix=sources/wham /path/to/wham main
```

Follow-up pulls use the same prefix:

```bash
git subtree pull --prefix=sources/wham https://github.com/Project-CETI/wham.git main
```

After every import or pull, update `tools/source_repos.yaml` with the imported
commit and any local patches that still need upstream contribution.
