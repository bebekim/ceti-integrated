# Core CETI Glossary

This glossary keeps shared terms stable across source repositories, dataset
contracts, packages, pipelines, and papers.

## Acoustic Terms

**Click**: A short broadband acoustic pulse produced by a sperm whale. Clicks
are the atomic timing events used to build codas and inter-click intervals.

**Coda**: A stereotyped sequence of clicks used in sperm whale social
communication. Coda records should preserve the ordered click times, recording
context, and whale attribution when known.

**Inter-click interval (ICI)**: The time gap between adjacent clicks in a coda.
ICI sequences are the basis for rhythm, tempo, rubato, and related timing
features.

**Rhythm**: A context-independent timing pattern describing the relative shape
of inter-click intervals in a coda.

**Tempo**: A context-independent timing scale describing the speed of a coda.

**Rubato**: A context-sensitive modulation of coda timing. In the
combinatoriality analysis, rubato varies with conversational context and can be
imitated across whales.

**Ornamentation**: A context-sensitive coda modification involving additional
or altered click structure beyond the base rhythm and tempo.

**Spectral vowel**: A spectral feature class used in vowel-phonology and WhAM
downstream classification contexts. It should be recorded separately from coda
timing features.

## Entity Terms

**Whale identity**: A stable identifier for an individual whale when known.
Unknown or uncertain identity should be explicit in dataset contracts rather
than inferred from file names alone.

**Social unit**: A stable social group of whales. Social-unit labels are used
by WhAM downstream classification and by behavioral analyses.

**Focal whale**: The whale selected as the primary subject for a recording,
track, event, or annotation.

## Collection Terms

**Tag**: A field device attached to or associated with a whale. Tag data may
include hydrophone audio and sensor streams.

**Mooring**: A stationary recording device or platform that contributes acoustic
or environmental data.

**Drone event**: A video collection event from a drone or related visual sensor,
usually tied to time, location, focal whale, and behavior annotations.

**Device ID**: A stable identifier for a recording or collection device.
Device IDs are required for field offload and manifest lineage.

## Data And Model Terms

**Raw data zone**: External storage for unmodified field or public source files.
The monorepo records manifests for these files, not the large files themselves.

**Validated dataset**: A dataset whose records conform to a schema, include
provenance, and can be reproduced from a manifest.

**Split**: A named partition of data, such as train, validation, test, field
season, whale, social unit, or paper-specific evaluation split.

**Embedding**: A vector representation produced by a model or feature extractor.
WhAM embeddings are used for downstream classification and comparison tasks.

**Model artifact**: A trained weight file, tokenizer, config, metrics output, or
other reproducible model result. Artifacts should include code version, input
dataset version, and storage location.
