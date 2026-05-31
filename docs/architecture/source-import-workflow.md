# Source Import Workflow

Imported repositories live under `sources/` and are maintained with
`git subtree` without squash. This preserves upstream history inside the
integrated repository while keeping new platform code outside imported trees.

## Rules

1. Keep imported source code under its configured `sources/` prefix.
2. Prefer wrappers in `packages/`, `pipelines/`, and `experiments/` over edits
   inside `sources/`.
3. If a source edit is unavoidable, keep it small and record it in
   `tools/source_repos.yaml` under `local_patches`.
4. After every subtree pull, update `last_imported_commit` in
   `tools/source_repos.yaml`.
5. Run relevant checks and commit the subtree pull separately from integration
   code.

## Pull Commands

Run these from the repository root.

```bash
git subtree pull --prefix=sources/wham https://github.com/Project-CETI/wham.git main
git subtree pull --prefix=sources/data-ingest https://github.com/Project-CETI/data-ingest.git main
git subtree pull --prefix=sources/whale-tag-embedded https://github.com/Project-CETI/whale-tag-embedded.git main
git subtree pull --prefix=sources/sw-combinatoriality https://github.com/Project-CETI/sw-combinatoriality.git main
git subtree pull --prefix=sources/coda-vowel-phonology https://github.com/Project-CETI/coda-vowel-phonology.git main
git subtree pull --prefix=sources/acoustics/pam-pipeline https://github.com/Project-CETI/Complete_automated_PAM_pipelne.git main
git subtree pull --prefix=sources/acoustics/click-presence-detector https://github.com/Project-CETI/Sperm_whale_click_presence_detector.git main
git subtree pull --prefix=sources/acoustics/localization https://github.com/Project-CETI/Sperm_whale_localization.git main
git subtree pull --prefix=sources/acoustics/ship-noise-analysis https://github.com/Project-CETI/Analysis-for-ship-noise.git main
git subtree pull --prefix=sources/acoustics/ship-noise-database https://github.com/Project-CETI/Database-for-ship-noise.git main
git subtree pull --prefix=sources/vision/segmentations-infrastructure https://github.com/Project-CETI/segmentations_infrastructure.git master
git subtree pull --prefix=sources/vision/whale-birth-analysis https://github.com/Project-CETI/whale-birth-data-and-analysis-suite.git main
git subtree pull --prefix=sources/theory/theory-of-umt https://github.com/Project-CETI/theory-of-umt.git main
```

`segmentations_infrastructure` uses `master`, matching the branch recorded in
`tools/source_repos.yaml`.

## Updating The Manifest

After a pull, record the upstream commit that was imported. For local clones,
the command is:

```bash
git -C /path/to/source-repo rev-parse <branch>
```

For remote-only checks, use:

```bash
git ls-remote https://github.com/Project-CETI/<repo>.git <branch>
```

Then update the matching entry in `tools/source_repos.yaml`:

```yaml
last_imported_commit: <commit-sha>
local_patches: []
```

If the integrated repository carries a local source change that has not gone
upstream, add a short note to `local_patches` instead of leaving the list empty.

## Recommended Commit Shape

Use separate commits for provenance and integration:

```bash
git add sources/<prefix> tools/source_repos.yaml
git commit -m "chore: pull <source-name> source updates"

git add packages pipelines datasets experiments docs
git commit -m "feat: integrate <source-name> update"
```

This keeps upstream history pulls reviewable and makes local integration changes
easy to reason about.
