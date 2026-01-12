# Z-Score Standardization

Standardizes a numeric vector by centering it to have a mean of 0 and
scaling it to have a standard deviation of 1.

## Usage

``` r
norm_zscore(x, na.rm = TRUE)
```

## Arguments

- x:

  A numeric vector.

- na.rm:

  Logical. Should NA values be removed during mean/sd calculation?
  Default is `TRUE`.

## Value

A numeric vector. If the input vector has zero variance (all values are
identical), the function returns a centered vector (all zeros) and
issues a warning.

## Details

Formula: \\z = \frac{x - \mu}{\sigma}\\

## References

Han, J., Kamber, M., & Pei, J. (2011). *Data mining: concepts and
techniques* (3rd ed.). Morgan Kaufmann.

## Examples

``` r
# Standard usage
norm_zscore(c(1, 2, 3, 4, 5))
#> [1] -1.2649111 -0.6324555  0.0000000  0.6324555  1.2649111

# Edge case: Zero variance
norm_zscore(c(5, 5, 5))
#> Warning: Standard deviation is zero. Returning centered vector (zeros).
#> [1] 0 0 0
```
