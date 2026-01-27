# QC object spec: qc_bundle (Day 1)

## Purpose

`qc_bundle` is the single carrier object for the QC pipeline in *prepkit*.  
Its purpose is to enforce stage boundaries (enable → assess → decide), prevent implicit modification of raw data, and provide an auditable trail of QC actions.

QC functions must operate by **adding derived objects / metadata** and must not overwrite raw observations.

---

## Minimal structure (required fields)

A `qc_bundle` is an S3 object backed by a `list` with the following required fields.  
Fields may be empty (`NULL`), but **must exist**.

1. `raw`  
   - Meaning: raw data (data.frame/tibble or reference)  
   - Rule: **read-only** after initialization (no stage may overwrite/replace it)

2. `meta`  
   - Meaning: metadata describing `raw` (id, device, expected sampling rate, time zone, channel semantics, axis definitions, protocol version, etc.)  
   - Rule: may be appended, but must not silently rewrite **key fields** (`id`, `tz`, `fs_expected`, `channels`)

3. `derived`  
   - Meaning: QC-enabling derived objects (window indices, expected grids, missingness masks, run-length summaries, auxiliary quantities for QC metrics)  
   - Rule: writable only by QC-enabling stage; must record derivation parameters

4. `metrics`  
   - Meaning: numeric QC assessment outputs (missingness rates, flatline ratios, saturation ratios, timestamp drift, variance collapse)  
   - Rule: writable only by QC assessment stage; must encode its evaluation unit (subject/day/window/channel)

5. `flags`  
   - Meaning: logical or categorical QC assessment outputs (e.g., `flag_flatline = TRUE`)  
   - Rule: writable only by QC assessment stage; must not imply automatic exclusion

6. `decision` (optional, may be `NULL`)  
   - Meaning: user-invoked QC decisions (exclusion, weighting, stratification) derived from assessment outputs  
   - Rule: writable only by QC decision stage; must record policy/rule/version; must not modify `raw`

7. `reasons`  
   - Meaning: human-readable decision reasons  
   - Rule: generated only by QC decision stage (assessment must not write reasons)

8. `log`  
   - Meaning: append-only audit log (time, stage, function, parameter summary, notes)  
   - Rule: append-only; no deletion of past entries

---

## Stage write permissions (responsibility boundaries)

A stage may **read** all fields, but may only **write** the following fields:

- Raw data (initialization): writes `raw`, `meta`, initializes empty containers
- QC-enabling preprocessing: writes `derived`, appends `log` (may append non-key notes to `meta`)
- QC assessment: writes `metrics`, `flags`, appends `log`
- QC decision: writes `decision`, `reasons`, appends `log` (must not recompute metrics/flags)
- Post-processing validation: may append `log` and processing-induced diagnostics (must not redefine raw QC)

---

## Units / granularity

All `metrics`, `flags`, and `decision` outputs must declare their evaluation unit:

`unit ∈ {subject, session, day, window, channel}`

Every output must answer: **“for which unit is this computed/applied?”**

---

## Stability rules

- Field names and meanings are stable over time.
- Extensions are allowed by adding new fields; changing semantics is considered breaking.
- `decision` must be exportable to a tabular form (data.frame) for methods reporting.
