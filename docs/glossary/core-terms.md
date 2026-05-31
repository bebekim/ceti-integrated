# Core CETI Glossary

This glossary keeps shared terms stable across source repositories, dataset
contracts, packages, pipelines, and papers.

## Acoustic Terms

**Click**: A short broadband acoustic pulse produced by a sperm whale. Clicks
are the atomic timing events used to build codas and inter-click intervals.

**Click presence**: A detection result indicating whether sperm whale
echolocation clicks are present in a short acoustic buffer.

**Coda**: A stereotyped sequence of clicks used in sperm whale social
communication. Coda records should preserve the ordered click times, recording
context, and whale attribution when known.

**Inter-click interval (ICI)**: The time gap between adjacent clicks in a coda.
ICI sequences are the basis for rhythm, tempo, rubato, and related timing
features.

**Passive acoustic monitoring (PAM)**: Acoustic monitoring that detects and
analyzes animal sounds from recorded audio without requiring visual observation.
In this repository, PAM outputs should become explicit detection, coda, or
feature records before reuse.

**Localization**: Estimating the position or bearing of a sound source from
acoustic observations. Localization records should state the array geometry,
timestamp, detection input, and uncertainty when available.

**Vertical array**: A hydrophone arrangement with sensors at different depths.
The localization source uses a two-element vertical array for sperm whale click
localization.

**Ship noise**: Acoustic noise associated with vessels. Ship-noise context
should be represented separately from whale vocalization features so analyses
can distinguish signal from environmental or anthropogenic noise.

**Rhythm**: A context-independent timing pattern describing the relative shape
of inter-click intervals in a coda.

**Tempo**: A context-independent timing scale describing the speed of a coda.

**Rubato**: A context-sensitive modulation of coda timing. In the
combinatoriality analysis, rubato varies with conversational context and can be
imitated across whales.

**Ornamentation**: A context-sensitive coda modification involving additional
or altered click structure beyond the base rhythm and tempo.

**Spectral peak**: A frequency peak found in the spectrum of a click. Spectral
peak positions are used by vowel-phonology analyses.

**Spectral vowel**: A spectral feature class used in vowel-phonology and WhAM
downstream classification contexts. It should be recorded separately from coda
timing features.

**Coarticulation**: A relationship between adjacent coda clicks or coda vowel
categories where the spectral properties of one click are analyzed in relation
to a neighboring click or coda.

## Entity Terms

**Whale identity**: A stable identifier for an individual whale when known.
Unknown or uncertain identity should be explicit in dataset contracts rather
than inferred from file names alone.

**Social unit**: A stable social group of whales. Social-unit labels are used
by WhAM downstream classification and by behavioral analyses.

**Focal whale**: The whale selected as the primary subject for a recording,
track, event, or annotation.

**Species**: The biological species represented by an annotation or track.
Vision segmentation infrastructure can carry species labels, so schemas should
not assume every object is a sperm whale unless stated.

## Collection And Device Terms

**Tag**: A field device attached to or associated with a whale. Tag data may
include hydrophone audio and sensor streams.

**Embedded tag image**: The operating-system image and installed packages used
on the tag computer deployed in the field.

**Data capture service**: The on-device process that records tag data into the
expected storage location during deployment.

**Debian package**: A packaged software unit used by `whale-tag-embedded` to
install and update tag software on the device image.

**Device ID**: A stable identifier for a recording or collection device. Device
IDs are required for field offload and manifest lineage.

**Mooring**: A stationary recording device or platform that contributes acoustic
or environmental data.

**Collection session**: A bounded period of field collection from a tag,
mooring, drone, or public source. Sessions should connect device, timestamp,
location, and manifest provenance.

## Vision And Behavior Terms

**Drone event**: A video collection event from a drone or related visual sensor,
usually tied to time, location, focal whale, and behavior annotations.

**Drone telemetry**: Per-frame or per-video sensor metadata from the drone, such
as GPS, altitude, speed, camera settings, and timestamps.

**Synchronized video**: Video streams whose frames can be aligned across devices
or drones. Synchronization should be explicit in manifests or schemas.

**Segmentation**: A visual annotation that identifies object regions in video or
image frames.

**Mask**: A pixel-level segmentation representation for one object or class in a
frame.

**Track**: A sequence of detections, masks, or positions that refer to the same
individual or object across frames.

**Bounding box**: A rectangular spatial summary of an object in an image frame.
Bounding boxes are convenient features but should not replace masks when mask
geometry is required.

**Orientation**: The estimated body direction or heading of a whale in a visual
frame or track.

**Proximity**: A derived spatial relationship between whales, usually computed
from tracks, orientation, or positions.

**Social network**: A graph representation of whale relationships or
interactions. Network-analysis outputs should retain the feature definitions and
time window used to create edges.

## Data And Model Terms

**Raw data zone**: External storage for unmodified field or public source files.
The monorepo records manifests for these files, not the large files themselves.

**Manifest**: A machine-readable inventory of data artifacts, storage
locations, checksums, provenance, licenses, and relevant collection metadata.

**Validated dataset**: A dataset whose records conform to a schema, include
provenance, and can be reproduced from a manifest.

**Schema**: A machine-readable contract for the shape and meaning of records
used by packages, pipelines, or experiments.

**Split**: A named partition of data, such as train, validation, test, field
season, whale, social unit, or paper-specific evaluation split.

**Embedding**: A vector representation produced by a model or feature extractor.
WhAM embeddings are used for downstream classification and comparison tasks.

**Model artifact**: A trained weight file, tokenizer, config, metrics output, or
other reproducible model result. Artifacts should include code version, input
dataset version, and storage location.

**Run metadata**: The recorded dataset version, code version, config, metrics,
environment, and output artifact location for a reproducible run.

**Unsupervised machine translation (UMT)**: A modeling setting where
translation-like structure is learned without paired examples. The theory source
uses UMT as a lens for animal communication.

**Sweep**: A set of experiment runs over parameter values, often managed by a
tool such as Weights & Biases. Sweep records should identify the config, code
version, and result location.
