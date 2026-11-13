# The Projects Inside This Repository — A Plain-Language Guide

Think of this repo as a bookshelf holding **13 separate research projects**
that different teams built for Project CETI — the attempt to understand sperm
whale communication with AI — plus empty shelves (`packages/`, `pipelines/`,
`experiments/`) where a unified platform will eventually be assembled.

Every project answers exactly one question. Walk through the questions in
order and the whole story makes sense.

## The backstory, fast

Sperm whales "talk" using **codas** — short bursts of clicks, like a drummer's
stroke. Different whales favour different coda types, and they appear to copy
each other during encounters. Project CETI records these conversations at sea
with underwater microphones, then uses signal processing, statistics, and
machine learning to find out whether codas are structured enough to be called
a language — letters, words, conversation rules and all.

## 1. "How do we even get the recordings?" (operations — 2 projects)

| Project | Language | The gist |
| --- | --- | --- |
| `sources/whale-tag-embedded/` | build/packaging | The software that runs *on the recording devices themselves* — tags glued to whales, recorders on gliders. It's what captures the audio at sea |
| `sources/data-ingest/` | Python | What happens when the devices come back: offload the files, tidy them up, ship them to Amazon S3 |

Everything else in this repo eats what these two produce. Note: the raw audio
does **not** live in this repository — just small tables derived from it.

## 2. "Where are the clicks in all that ocean noise?" (detection — 4 projects)

| Project | Language | The gist |
| --- | --- | --- |
| `sources/acoustics/pam-pipeline/` | MATLAB | The main listening machine. It scans hours of hydrophone audio, spots the clicks, bundles them into codas, and — the hard part — works out *which whale* clicked what when several are calling at once |
| `sources/acoustics/click-presence-detector/` | MATLAB | The tiny version of the same question: "is there a sperm whale click in this snippet? yes/no" |
| `sources/acoustics/ship-noise-analysis/` | MATLAB | Ships roar through the same water and confuse the detectors. These measure the noise |
| `sources/acoustics/ship-noise-database/` | data files | ...and keep the records of it |

This is where *sound becomes data*. Everything after this row works with
tables of click-times — spreadsheets, not terabytes of audio.

## 3. "What are the letters of the whale alphabet?" (structure — 2 projects)

| Project | Language | The gist |
| --- | --- | --- |
| `sources/sw-combinatoriality/` | Python notebooks | The "alphabet" result. Every coda gets labelled on four features — **rhythm, tempo, rubato, ornamentation** — functioning a lot like consonants and vowels. The paper shows these features *combine* into a far bigger vocabulary than anyone thought, carry real information, and get *imitated between whales mid-conversation* |
| `sources/coda-vowel-phonology/` | R + Python notebook | The follow-on twist: codas don't only differ by click timing. Each click also has a spectral "vowel" flavour ('a' or 'i'), assigned by human ears and by an automated spectral analysis — and whales bend neighbouring clicks into each other, just like we co-articulate vowels in speech |

## 4. "Who is where, and what are they doing?" (localization + vision — 3 projects)

| Project | Language | The gist |
| --- | --- | --- |
| `sources/acoustics/localization/` | MATLAB | Two microphones a few metres apart hear each click at slightly different times. From that, triangulate *where* the calling whale actually is |
| `sources/vision/segmentations-infrastructure/` | Python | Drone video tooling: cut individual whales out of footage, frame by frame |
| `sources/vision/whale-birth-analysis/` | Python | Follows tagged whales through drone video, measures who hangs out near whom, builds social networks around births — the non-acoustic proof that these relationships matter |

## 5. "Can a machine learn to speak — or translate — whale?" (models & theory — 2 projects)

| Project | Language | The gist |
| --- | --- | --- |
| `sources/wham/` | Python | **WhAM**, the transformer that listens to raw coda audio directly (no spreadsheets in between). It can generate convincing new codas, "style-transfer" any sound — even human speech — into coda-like texture, and produce embeddings that classify whales by social unit. The deep-learning crown jewel |
| `sources/theory/theory-of-umt/` | Python | The skeptical backbone. Unsupervised machine translation is what "decoding whale language" would require — with *no bilingual dictionary to learn from*. These simulations map out when that could honestly work and when it's wishful thinking |

## How it all ties together

Each row hands off to the next:

```text
tags & recorders ──► S3 archive ──► click/coda tables ──► alphabet labels
(whale-tag-embedded) (data-ingest)   (pam-pipeline)      (sw-combinatoriality)
                                          │               (vowel-phonology)
                                          ▼
                                   where & who ◄─── drone video
                                 (localization)   (vision projects)
                                          │
                                          ▼
                     WhAM learns the audio directly ◄── theory-of-umt
                     (can we generate/translate?)     (can we decode at all?)
```

Two evidence streams — ears (acoustic) and eyes (vision) — meet in the middle
at the whales' social lives. Theory keeps the interpretation honest, and WhAM
is the statistical engine trained on the sound itself.

The concrete glue is `datasets/schemas/codas.schema.json`: one row per coda,
with its click times and its labels from both structure papers. That schema is
the handshake between projects — and the reason they can be combined later
without arguing about formats.

## Where new code goes (this repo's own rule)

`sources/` is history — imported upstream work, left exactly as its authors
wrote it, MATLAB and all. Anything new that wraps, ports, or combines their
outputs lives in:

- `packages/` — reusable libraries (acoustics, data, models, vision)
- `pipelines/` — repeatable data flows between them
- `experiments/` — one folder per paper being reproduced (e.g.
  `experiments/combinatoriality/` for the alphabet paper)
- `docs/` — architecture, vocabulary, data contracts
