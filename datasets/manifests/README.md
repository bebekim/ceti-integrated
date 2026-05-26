# Dataset Manifests

Manifests describe data stored outside this repository. Do not commit large raw
audio, video, model weights, or field-device dumps here.

Each manifest should include:

- `dataset_id`
- `dataset_version`
- `storage_uri`
- `schema`
- `checksum` or another content integrity field
- `provenance`
- `license`
- `access_notes`
- `created_at_utc`

The first expected manifests are for raw ingest outputs, coda records, click
records, whale metadata, and WhAM-ready audio examples.
