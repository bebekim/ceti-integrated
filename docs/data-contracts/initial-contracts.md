# Initial Dataset Contracts

The first contracts cover the minimum records needed to connect the imported
ingest, combinatoriality, and WhAM source repositories.

These contracts are intentionally small. They define stable integration shapes,
not every column in every upstream notebook or script.

## Contract Files

| Contract | Schema | Primary consumers |
| --- | --- | --- |
| Coda record | [`datasets/schemas/codas.schema.json`](../../datasets/schemas/codas.schema.json) | `packages/ceti-acoustics`, `experiments/combinatoriality`, `sources/wham` evaluation |
| Click record | [`datasets/schemas/clicks.schema.json`](../../datasets/schemas/clicks.schema.json) | `packages/ceti-acoustics`, coda extraction, localization adapters |
| Whale record | [`datasets/schemas/whales.schema.json`](../../datasets/schemas/whales.schema.json) | social-unit classification, metadata joins, evaluation splits |
| WhAM audio example | [`datasets/schemas/wham_audio_examples.schema.json`](../../datasets/schemas/wham_audio_examples.schema.json) | `packages/ceti-models`, `experiments/wham`, WhAM embedding/evaluation wrappers |

## Shared Requirements

Every dataset manifest that points to records using these schemas should include:

- `dataset_id`: stable name for the dataset.
- `dataset_version`: immutable version or content hash.
- `storage_uri`: external location for data files.
- `schema`: path or URI for the schema used to validate records.
- `provenance`: source repository, source command, field season, public dataset,
  or paper artifact that produced the records.
- `license`: data-use and access notes.

## Integration Rules

1. Large audio, video, model weights, and raw field files stay outside git.
2. Dataset records must not depend on local absolute file paths.
3. Unknown whale identity, social unit, or timestamp values must be represented
   explicitly as `null`.
4. Time values use UTC ISO 8601 strings where available.
5. Durations and offsets use seconds.
6. Audio sample rates use hertz.
7. Model-ready WhAM examples must record both the audio file URI and the split.
8. Any experiment that consumes these records must record the schema version and
   dataset version in its run metadata.
