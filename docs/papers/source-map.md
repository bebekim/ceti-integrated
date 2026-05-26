# Paper And Result Source Map

This map links scientific result areas to the imported source repositories and
the project-level homes where reproducible wrappers should be added.

| Result area | Imported source | Project-level home | Notes |
| --- | --- | --- | --- |
| WhAM generation, embeddings, downstream classification, and FAD metrics | [`sources/wham/`](../../sources/wham/) | `packages/ceti-models`, `experiments/wham`, `pipelines/evaluation` | Keep model code in source initially. Add wrappers for stable inference, embedding extraction, and evaluation metadata. |
| Field-device offload and raw S3 upload | [`sources/data-ingest/`](../../sources/data-ingest/) | `pipelines/ingest`, `datasets/manifests`, `packages/ceti-data` | Use imported CLI behavior as the operational source of truth, then validate uploaded inventory through manifests. |
| Contextual and combinatorial structure in sperm whale vocalisations | [`sources/sw-combinatoriality/`](../../sources/sw-combinatoriality/) | `packages/ceti-acoustics`, `experiments/combinatoriality`, `pipelines/feature-builds` | Start by preserving notebooks and data artifacts. Extract stable coda timing feature interfaces only after contract shapes are validated. |

## Reproduction Direction

The first reproducible end-to-end target should be small:

```text
manifested coda records
  -> validated coda schema
  -> combinatoriality feature table
  -> WhAM-ready audio examples or embeddings
  -> evaluation output with dataset, code, and config versions
```

This avoids needing to normalize every imported repository before proving the
monorepo can connect source history, dataset contracts, and model evaluation.
