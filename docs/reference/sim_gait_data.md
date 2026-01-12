# Simulated Geriatric Gait Data

A synthetic longitudinal dataset representing daily step counts of an
older adult. Used to demonstrate the "Vanishing Variance" problem.

## Usage

``` r
data(sim_gait_data)
```

## Format

A data frame with 200 rows and 2 variables:

- day:

  Integer. Time index (Days 1-200).

- steps:

  Numeric. Daily step count with habitual plateau and anomalies.

## Source

Generated via simulation logic in data-raw/.
