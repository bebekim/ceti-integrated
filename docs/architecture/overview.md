# CETI Integrated Architecture Overview

## Purpose

`ceti-integrated` is the project-level home for turning Project CETI research
repositories into a coherent AI and data platform. It keeps upstream repository
history intact under `sources/` and puts new integration code, contracts, and
reproducible workflows outside those imported trees.

The central rule is simple: imported repositories are provenance, while
`packages/`, `pipelines/`, `datasets/`, `experiments/`, and `docs/` are the
integration layer.

## Domain Map

The imported repositories now cover six project domains:

```text
field collection and embedded tags
  -> sources/whale-tag-embedded
  -> sources/data-ingest
  -> datasets/manifests

acoustic detection, localization, and ship-noise context
  -> sources/acoustics/pam-pipeline
  -> sources/acoustics/click-presence-detector
  -> sources/acoustics/localization
  -> sources/acoustics/ship-noise-analysis
  -> sources/acoustics/ship-noise-database
  -> packages/ceti-acoustics

coda structure and spectral-vowel analyses
  -> sources/sw-combinatoriality
  -> sources/coda-vowel-phonology
  -> packages/ceti-acoustics
  -> experiments/combinatoriality and experiments/vowel-phonology

modeling and evaluation
  -> sources/wham
  -> packages/ceti-models
  -> experiments/wham and pipelines/evaluation

vision, segmentation, and social behavior
  -> sources/vision/segmentations-infrastructure
  -> sources/vision/whale-birth-analysis
  -> packages/ceti-vision
  -> experiments/social-behavior

theory and simulation
  -> sources/theory/theory-of-umt
  -> experiments and docs/papers
```

This is intentionally modular. Each source repo remains runnable on its own
terms; the integrated project grows stable wrappers and contracts only around
concepts that need to cross source boundaries.

## Imported Source Responsibilities

### Field Collection

`sources/whale-tag-embedded` owns the Raspberry Pi tag image, Debian packages,
hostname setup, and data-capture service used on deployed whale tags.

`sources/data-ingest` owns field-device offload and upload mechanics. It
includes the `ceti` CLI for whale tag discovery/offload, generic non-tag
offload, local staging, backup, compression, and S3 upload.

Platform boundary:

- `pipelines/ingest` should call or wrap these tools with run metadata.
- `datasets/manifests` should describe produced files, storage URIs, checksums,
  devices, and collection sessions.
- `packages/ceti-data` should validate manifests after files land in storage.

### Acoustic Processing

`sources/acoustics/pam-pipeline` owns the Matlab passive acoustic monitoring
pipeline for sperm whale signals.

`sources/acoustics/click-presence-detector` owns Matlab click-presence detection
for short buffers.

`sources/acoustics/localization` owns Matlab localization experiments and
utilities for two-element vertical array click localization.

`sources/acoustics/ship-noise-analysis` and
`sources/acoustics/ship-noise-database` own ship-noise analysis scripts and
supporting tabular outputs.

Platform boundary:

- `packages/ceti-acoustics` should expose reusable click, detection,
  localization, and noise-context record types.
- `pipelines/feature-builds` should orchestrate detection, localization, and
  feature extraction once contracts exist.
- `datasets/schemas` should define the common records before cross-repo
  acoustic outputs are joined.

### Coda Structure And Spectral Vowels

`sources/sw-combinatoriality` owns the published combinatoriality notebooks and
data artifacts for rhythm, tempo, rubato, ornamentation, and information
capacity.

`sources/coda-vowel-phonology` owns coda vowel metadata, spectral analysis
tables, and coarticulation metadata for the sperm whale coda vowel analysis.

Platform boundary:

- `packages/ceti-acoustics` should expose reusable coda timing, spectral peak,
  vowel, and coarticulation types.
- `experiments/combinatoriality` and `experiments/vowel-phonology` should hold
  reproducible configs for paper regeneration.
- `datasets/schemas/codas.schema.json` should remain the shared coda contract
  and be extended carefully before downstream code depends on new fields.

### Modeling

`sources/wham` owns WhAM model code, inherited VampNet components, generation
scripts, embedding workflows, downstream classification, and generative metrics.

Platform boundary:

- `packages/ceti-models` should expose stable inference, embedding, training,
  and evaluation interfaces.
- `experiments/wham` should hold model and dataset configurations.
- `datasets/schemas/wham_audio_examples.schema.json` should define model-ready
  audio examples before training or evaluation pipelines depend on them.

### Vision And Social Behavior

`sources/vision/segmentations-infrastructure` owns helpers for loading,
parsing, visualizing, creating, and editing video segmentations. It also reads
drone telemetry and synchronized videos.

`sources/vision/whale-birth-analysis` owns the whale tracking, alignment,
orientation, feature extraction, and network-analysis workflows used for the
birth and social-complexity study.

Platform boundary:

- `packages/ceti-vision` should expose segmentation, mask, track, orientation,
  drone telemetry, and social-behavior feature types.
- `pipelines/feature-builds` should build visual and social feature tables from
  validated segmentation and drone inputs.
- `experiments/social-behavior` should hold reproducible configs for paper
  figure and network-analysis regeneration.

### Theory

`sources/theory/theory-of-umt` owns experiments for unsupervised translation
theory motivated by animal communication, including simulation code and
Weights & Biases sweep configs.

Platform boundary:

- Keep theory experiment code in source until there is a shared simulation or
  evaluation abstraction.
- Record reproducible theory runs under `experiments/` when they become part
  of integrated project comparisons.
- Use `docs/papers/source-map.md` to connect theory results to the imported
  code and any future platform wrappers.

## New Platform Responsibilities

### `packages/`

Reusable Python APIs. These packages should be small, dependency-aware wrappers
around stable concepts:

- `ceti-core`: paths, configuration, run metadata, logging, project constants.
- `ceti-data`: manifest readers, schema validation, lineage, dataset splits.
- `ceti-acoustics`: clicks, codas, inter-click intervals, detection outputs,
  localization outputs, ship-noise context, rhythm, tempo, rubato,
  ornamentation, spectral peaks, and coda vowels.
- `ceti-vision`: drone metadata, synchronized video, segmentations, masks,
  tracks, orientation, proximity, and social behavior features.
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

Initial imports and follow-up pulls use `git subtree` without squash so
upstream history remains in the integrated repository. The concrete maintenance
commands live in
[`docs/architecture/source-import-workflow.md`](source-import-workflow.md).

After every import or pull, update `tools/source_repos.yaml` with the imported
commit and any local patches that still need upstream contribution.
