# M-Score (Mode-Range Normalization)

Unlike Z-Score or Min-Max, the M-Score algorithm identifies the "Mode
Range" (the most frequent value range) and maps it to 0. This
effectively suppresses the noise of daily routine (e.g., stable step
counts) and amplifies anomalies (e.g., frailty or sudden activity).

It maps:

- **Mode Range**: \\\[k_L, k_R\] \to 0\\ (Baseline/Routine)

- **Left Tail**: \\\[min, k_L) \to \[-1, 0)\\ (Decline/Frailty)

- **Right Tail**: \\(k_R, max\] \to (0, 1\]\\ (Surge/Hyperactivity)

## Usage

``` r
norm_mode_range(x, tau = 0.8, digits = 0)
```

## Arguments

- x:

  A numeric vector.

- tau:

  A numeric value (0 to 1). The threshold ratio for defining the mode
  plateau. Bins with `freq >= tau * max_freq` are considered part of the
  routine. Default is 0.8.

- digits:

  Integer or NULL. If not NULL, values are rounded to this many decimal
  places **solely for identifying the mode**. This makes the algorithm
  robust against sensor noise (e.g., 1.0001 vs 1.0002). Default is 0
  (rounds to integer), which is ideal for step counts or heart rates.
  Set to `NULL` to disable rounding.

## Value

A numeric vector in the range \[-1, 1\].

## Details

A robust normalization method designed for longitudinal behavioral data
with a "routine plateau". Also known as Mode-Range Normalization (MRN).

## References

Gong, R. (2026). M-Score: A Robust Normalization Method for Detecting
Anomalies in Longitudinal Behavioral Data. *arXiv prepkitint*.
(Submitted)

## Examples

``` r
# Scenario 1: Integer data (Standard)
steps <- c(3000, 3000, 200, 5000)
norm_mode_range(steps)
#> [1]  0  0 -1  1

# Scenario 2: Noisy Sensor Data (Floating point)
# Without 'digits', these would be seen as different values.
# With digits=1, they are grouped into the same mode.
sensor_data <- c(9.81, 9.82, 9.80, 2.5, 15.0)
norm_mode_range(sensor_data, digits = 1)
#> [1]  0  0  0 -1  1
```
