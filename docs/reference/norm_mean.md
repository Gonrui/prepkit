# Mean Normalization

Scales a numeric vector by centering it around its mean and scaling it
by its range. The resulting vector has a mean of 0 and values typically
within \[-1, 1\].

## Usage

``` r
norm_mean(x, na.rm = TRUE)
```

## Arguments

- x:

  A numeric vector.

- na.rm:

  Logical. Should NA values be removed during calculation? Default is
  `TRUE`.

## Value

A numeric vector. If the range is 0 (all values are identical), returns
a centered vector (zeros).

## Details

Formula: \\x' = \frac{x - \text{mean}(x)}{\max(x) - \min(x)}\\

## References

Han, J., Kamber, M., & Pei, J. (2011). *Data mining: concepts and
techniques* (3rd ed.). Morgan Kaufmann.

## Examples

``` r
# Result ranges from approx -0.5 to 0.5, mean is 0
norm_mean(c(1, 2, 3, 4, 5))
#> [1] -0.50 -0.25  0.00  0.25  0.50

# Handles negative values
norm_mean(c(-10, 0, 10))
#> [1] -0.5  0.0  0.5
```
