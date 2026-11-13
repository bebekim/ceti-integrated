# Paper And Result Source Map

This map links each imported source repository to the analytical level it
serves in the effort to understand sperm whale communication, and to the
project-level home where reproducible wrappers should be added.

Sources are organised by a stack of analytical levels. Each level removes one
obstacle to the core question — *is this a language, and what does it mean?*

```text
L0  corpus           — recorded evidence
L1  segmentation     — turning sound into per-speaker utterances
L2  alphabet         — the discrete feature set (timing + spectral)
L2.5 identity        — who uses which features; clan dialectology
L3  channel          — callers in space; noise context
L4  social world      — the relationships meaning refers into
L4.5 playback        — perturbation experiments that test reference
L5  generative model — can a machine hold the system?
L6  theory           — what could "decoding" ever mean?
```

## L0 — Corpus (recorded evidence)

| Result area | Imported source | Project-level home | Notes |
| --- | --- | --- | --- |
| Embedded tag image, tag hostname setup, and on-device data capture | [`sources/whale-tag-embedded/`](../../sources/whale-tag-embedded/) | `pipelines/ingest`, `datasets/manifests`, `packages/ceti-data` | Keep tag image and Debian package mechanics in source. Capture device IDs, package versions, and deployment sessions in manifests. |
| Field-device offload and raw S3 upload | [`sources/data-ingest/`](../../sources/data-ingest/) | `pipelines/ingest`, `datasets/manifests`, `packages/ceti-data` | Use imported CLI behavior as the operational source of truth, then validate uploaded inventory through manifests. |

## L1 — Segmentation (sound → per-speaker utterances)

| Result area | Imported source | Project-level home | Notes |
| --- | --- | --- | --- |
| Passive acoustic monitoring for sperm whale signals | [`sources/acoustics/pam-pipeline/`](../../sources/acoustics/pam-pipeline/) | `packages/ceti-acoustics`, `pipelines/feature-builds`, `datasets/schemas` | Preserve Matlab implementation. Wrap only stable PAM outputs once detection and coda contracts are explicit. The click-separation step is what makes *per-speaker* conversation analysis possible. |
| Short-buffer click-presence detection | [`sources/acoustics/click-presence-detector/`](../../sources/acoustics/click-presence-detector/) | `packages/ceti-acoustics`, `pipelines/feature-builds`, `datasets/schemas` | Treat detector output as an acoustic event table before joining to coda or localization records. |

## L2 — Alphabet (the discrete feature set)

| Result area | Imported source | Project-level home | Notes |
| --- | --- | --- | --- |
| Contextual and combinatorial structure in sperm whale vocalisations (rhythm, tempo, rubato, ornamentation) | [`sources/sw-combinatoriality/`](../../sources/sw-combinatoriality/) | `packages/ceti-acoustics`, `experiments/combinatoriality`, `pipelines/feature-builds` | Sharma et al., *Nature Communications* 2024 — the "phonetic alphabet" result. Start by preserving notebooks and data artifacts. Extract stable coda timing feature interfaces only after contract shapes are validated. |
| Coda vowel phonology and coarticulation (spectral 'a'/'i' vowels) | [`sources/coda-vowel-phonology/`](../../sources/coda-vowel-phonology/) | `packages/ceti-acoustics`, `experiments/vowel-phonology`, `datasets/schemas` | Beguš et al., bioRxiv 2025. Spectral-vowel and coarticulation tables should extend coda/click contracts rather than create an unrelated vocabulary. |

## L2.5 — Identity & dialect (who uses which features)

Sperm whale clans have culturally-transmitted vocal repertoires (dialects).
This level — where the alphabet meets social group membership — is currently
only implicit in the imported sources (the combinatoriality paper notes codas
carry caller/clan identity, but no imported repo makes clan dialectology its
primary target). It is the bridge from "structure" to "group meaning".

| Result area | Imported source | Project-level home | Notes |
| --- | --- | --- | --- |
| Cross-population / cross-clan comparison data | [`sources/robotics/glider-backseat-driver/`](../../sources/robotics/glider-backseat-driver/) | `datasets/manifests`, `experiments/dialectology` | Seaglider (SEA023) field-experiment telemetry from France — a different ocean and likely a different vocal clan than Dominica. **Verification needed:** the repo has no README and contains only `.gli`/`.pld1` CSVs; whether it carries acoustic recordings suitable for cross-clan dialect comparison must be confirmed before reuse. Flagged as the level's seed dataset pending that check. |

## L3 — Channel (callers in space; noise context)

| Result area | Imported source | Project-level home | Notes |
| --- | --- | --- | --- |
| Two-element vertical-array click localization | [`sources/acoustics/localization/`](../../sources/acoustics/localization/) | `packages/ceti-acoustics`, `pipelines/feature-builds`, `datasets/schemas` | Define localization output contracts before integrating positions with whale identity, tracks, or behavior features. |
| Ship-noise context and analysis | [`sources/acoustics/ship-noise-analysis/`](../../sources/acoustics/ship-noise-analysis/) | `packages/ceti-acoustics`, `datasets/manifests`, `pipelines/feature-builds` | Keep analysis scripts in source. Manifest vessel/noise inputs and expose reusable noise-context features later. |
| Ship-noise database outputs | [`sources/acoustics/ship-noise-database/`](../../sources/acoustics/ship-noise-database/) | `datasets/manifests`, `datasets/schemas`, `packages/ceti-data` | Treat spreadsheets and CSV outputs as data artifacts that need provenance, schema, and license metadata before reuse. |

## L4 — Social world (the relationships meaning refers into)

| Result area | Imported source | Project-level home | Notes |
| --- | --- | --- | --- |
| Video segmentation parsing, visualization, editing, and drone telemetry | [`sources/vision/segmentations-infrastructure/`](../../sources/vision/segmentations-infrastructure/) | `packages/ceti-vision`, `datasets/schemas`, `pipelines/feature-builds` | Use this as the source of truth for segmentation and drone telemetry semantics before defining vision schemas. |
| Whale tracking, orientation, birth analysis, and social network analysis | [`sources/vision/whale-birth-analysis/`](../../sources/vision/whale-birth-analysis/) | `packages/ceti-vision`, `experiments/social-behavior`, `pipelines/feature-builds` | Maalouf, DelPreto et al. — "Cooperation by non-kin during birth underpins sperm whale social complexity". Preserve the interactive tracking workflow. Extract stable feature-table and network-analysis interfaces after data contracts are clear. |
| Social-dynamics-driven unit movement | [`sources/behavior/mesoscale-movements/`](../../sources/behavior/mesoscale-movements/) | `packages/ceti-vision`, `experiments/social-behavior`, `datasets/schemas` | Supplementary data (IPI estimates + unit presence/absence) for a paper predicting sperm whale unit movements from social dynamics. If codas coordinate that movement, this is behavioral evidence that coda content has *referential* force, not just bonding. |

## L4.5 — Playback (perturbation experiments that test reference)

This level — using synthetic or controlled stimuli to test whether codas mean
something to the receiver — is the open frontier for the "reference" question.
It is seeded here by the AVATARS robotics work: an autonomous platform that
can approach a whale is the hardware prerequisite for controllable stimulus
experiments.

| Result area | Imported source | Project-level home | Notes |
| --- | --- | --- | --- |
| Autonomous whale rendezvous via RL + VHF/AOA sensing | [`sources/robotics/avatars-code/`](../../sources/robotics/avatars-code/) | `packages/ceti-robotics`, `experiments/playback` | "Reinforcement Learning-Based Framework for Whale Rendezvous via Autonomous Sensing Robots", *Science Robotics* 2024. Drones compute VHF angle-of-arrival from trajectory (synthetic-aperture) and run multi-agent RL to rendezvous with whales. Provides the controllable-platform substrate for future playback studies. |
| AVATARS datasets (acoustic + VHF + GPS field data) | [`sources/robotics/avatars-data/`](../../sources/robotics/avatars-data/) | `datasets/manifests`, `experiments/playback` | Field data companion to `avatars-code` (Dominica Nov 2023 / Feb 2024 + Horn Pond + Ohiri field tests). Manifest sensor types, flight sessions, and ground truth before reuse. |

## L5 — Generative model (can a machine hold the system?)

| Result area | Imported source | Project-level home | Notes |
| --- | --- | --- | --- |
| WhAM generation, embeddings, downstream classification, and FAD metrics | [`sources/wham/`](../../sources/wham/) | `packages/ceti-models`, `experiments/wham`, `pipelines/evaluation` | Paradise et al., NeurIPS 2025. Keep model code in source initially. Add wrappers for stable inference, embedding extraction, and evaluation metadata. Generation is an independent confirmation the combinatorial structure is learnable from audio; embeddings quantify which distinctions are present; pseudocodas enable playback stimuli. |

## L6 — Theory (what could "decoding" ever mean?)

| Result area | Imported source | Project-level home | Notes |
| --- | --- | --- | --- |
| Unsupervised translation theory simulations | [`sources/theory/theory-of-umt/`](../../sources/theory/theory-of-umt/) | `experiments`, `packages/ceti-models`, `docs/papers` | Goldwasser, Gruber, Kalai, Paradise, NeurIPS 2023. Keep simulation and sweep code in source. Add integrated experiment metadata only when theory runs are compared with project model outputs. Defines the structural conditions under which unsupervised whale→human translation is provably possible. |

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

A future robotics/playback target bridges L5 to L4.5:

```text
WhAM synthetic coda stimulus
  -> AVATARS platform positioning near a focal whale
  -> response recording (acoustic + visual)
  -> playback experiment output with stimulus, context, and response versions
```

This avoids normalizing every imported repository before proving the monorepo
can connect source history, dataset contracts, and reproducible outputs.
