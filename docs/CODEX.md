# CODEX: prepkit Progress Tracker

## Project Snapshot

- Name: prepkit
- Type: R package for data normalization and transformation
- Focus: gerontology, digital health, sensor analytics
- Flagship: M-Score (mode-range normalization) via
  [`norm_mode_range()`](https://gonrui.github.io/prepkit/reference/norm_mode_range.md)
- Status: CRAN submission-ready per DEV_LOG (2026-01-20), test coverage
  100%

## Repository Map

- R/: core functions (norm\_*, trans\_*, pp_plot)
- man/: Rd docs for all exported functions
- tests/: testthat coverage across all functions
- data/: sim_gait_data.rda (simulated gait dataset)
- data-raw/: dataset generation scripts
- inst/notes_cn/: Chinese notes (excluded from builds)
- docs/: pkgdown site output

## CI Policy (GitHub Actions)

- Default: Linux only (ubuntu-latest, R release) for push/PR
- Full matrix: manual workflow_dispatch with `full_matrix=true`

## Releases and Versioning

- Latest NEWS: 0.1.1 CRAN submission bump
- DESCRIPTION version: 0.1.1

## Recent Milestones (from DEV_LOG)

- CRAN compliance fixes (DESCRIPTION, .Rbuildignore)
- Full QA pass: spell check, examples, R CMD check (0/0/0)
- pkgdown site rebuilt and deployed
- Coverage locked at 100%

## Open Questions

- Define criteria for “major update” that triggers full CI matrix

## Next Steps (Suggested)

- Submit package to CRAN
- Continue manuscript preparation for M-Score
- Explore Python prototype or C++ acceleration when needed
