# Paper And Result Source Map

This map links scientific result areas to imported source repositories and the
project-level homes where reproducible wrappers should be added.

| Result area | Imported source | Project-level home | Notes |
| --- | --- | --- | --- |
| Embedded tag image, tag hostname setup, and on-device data capture | [`sources/whale-tag-embedded/`](../../sources/whale-tag-embedded/) | `pipelines/ingest`, `datasets/manifests`, `packages/ceti-data` | Keep tag image and Debian package mechanics in source. Capture device IDs, package versions, and deployment sessions in manifests. |
| Field-device offload and raw S3 upload | [`sources/data-ingest/`](../../sources/data-ingest/) | `pipelines/ingest`, `datasets/manifests`, `packages/ceti-data` | Use imported CLI behavior as the operational source of truth, then validate uploaded inventory through manifests. |
| Passive acoustic monitoring for sperm whale signals | [`sources/acoustics/pam-pipeline/`](../../sources/acoustics/pam-pipeline/) | `packages/ceti-acoustics`, `pipelines/feature-builds`, `datasets/schemas` | Preserve Matlab implementation. Wrap only stable PAM outputs once detection and coda contracts are explicit. |
| Short-buffer click-presence detection | [`sources/acoustics/click-presence-detector/`](../../sources/acoustics/click-presence-detector/) | `packages/ceti-acoustics`, `pipelines/feature-builds`, `datasets/schemas` | Treat detector output as an acoustic event table before joining to coda or localization records. |
| Two-element vertical-array click localization | [`sources/acoustics/localization/`](../../sources/acoustics/localization/) | `packages/ceti-acoustics`, `pipelines/feature-builds`, `datasets/schemas` | Define localization output contracts before integrating positions with whale identity, tracks, or behavior features. |
| Ship-noise context and analysis | [`sources/acoustics/ship-noise-analysis/`](../../sources/acoustics/ship-noise-analysis/) | `packages/ceti-acoustics`, `datasets/manifests`, `pipelines/feature-builds` | Keep analysis scripts in source. Manifest vessel/noise inputs and expose reusable noise-context features later. |
| Ship-noise database outputs | [`sources/acoustics/ship-noise-database/`](../../sources/acoustics/ship-noise-database/) | `datasets/manifests`, `datasets/schemas`, `packages/ceti-data` | Treat spreadsheets and CSV outputs as data artifacts that need provenance, schema, and license metadata before reuse. |
| Contextual and combinatorial structure in sperm whale vocalisations | [`sources/sw-combinatoriality/`](../../sources/sw-combinatoriality/) | `packages/ceti-acoustics`, `experiments/combinatoriality`, `pipelines/feature-builds` | Start by preserving notebooks and data artifacts. Extract stable coda timing feature interfaces only after contract shapes are validated. |
| Coda vowel phonology and coarticulation | [`sources/coda-vowel-phonology/`](../../sources/coda-vowel-phonology/) | `packages/ceti-acoustics`, `experiments/vowel-phonology`, `datasets/schemas` | Spectral-vowel and coarticulation tables should extend coda/click contracts rather than create an unrelated vocabulary. |
| WhAM generation, embeddings, downstream classification, and FAD metrics | [`sources/wham/`](../../sources/wham/) | `packages/ceti-models`, `experiments/wham`, `pipelines/evaluation` | Keep model code in source initially. Add wrappers for stable inference, embedding extraction, and evaluation metadata. |
| Video segmentation parsing, visualization, editing, and drone telemetry | [`sources/vision/segmentations-infrastructure/`](../../sources/vision/segmentations-infrastructure/) | `packages/ceti-vision`, `datasets/schemas`, `pipelines/feature-builds` | Use this as the source of truth for segmentation and drone telemetry semantics before defining vision schemas. |
| Whale tracking, orientation, birth analysis, and social network analysis | [`sources/vision/whale-birth-analysis/`](../../sources/vision/whale-birth-analysis/) | `packages/ceti-vision`, `experiments/social-behavior`, `pipelines/feature-builds` | Preserve the interactive tracking workflow. Extract stable feature-table and network-analysis interfaces after data contracts are clear. |
| Unsupervised translation theory simulations | [`sources/theory/theory-of-umt/`](../../sources/theory/theory-of-umt/) | `experiments`, `packages/ceti-models`, `docs/papers` | Keep simulation and sweep code in source. Add integrated experiment metadata only when theory runs are compared with project model outputs. |

## Reproduction Direction

The first reproducible end-to-end target should stay small and acoustic-first:

```text
manifested coda or click records
  -> validated acoustic schemas
  -> coda timing, spectral vowel, or click-detection feature table
  -> WhAM-ready audio examples or embeddings
  -> evaluation output with dataset, code, and config versions
```

The first vision/social target should be independent:

```text
manifested drone video and segmentation records
  -> validated segmentation and drone telemetry schemas
  -> track, orientation, and proximity feature table
  -> social-behavior experiment output with data and code versions
```

This avoids normalizing every imported repository before proving the monorepo
can connect source history, dataset contracts, and reproducible outputs.
