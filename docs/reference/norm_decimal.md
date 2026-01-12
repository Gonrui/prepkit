# Decimal Scaling Normalization

Normalizes a numeric vector by moving the decimal point of values of
attribute A. The number of decimal points moved depends on the maximum
absolute value of A.

## Usage

``` r
norm_decimal(x, na.rm = TRUE)
```

## Arguments

- x:

  A numeric vector.

- na.rm:

  Logical. Should NA values be ignored when determining the scaling
  factor? Default is `TRUE`.

## Value

A numeric vector with values typically in the range (-1, 1).

## Details

Formula: \\x' = \frac{x}{10^j}\\ where \\j\\ is the smallest integer
such that \\\max(\|x'\|) \< 1\\.

## References

Han, J., Kamber, M., & Pei, J. (2011). *Data mining: concepts and
techniques* (3rd ed.). Morgan Kaufmann.

## Examples

``` r
# Max value is 980, so j=3 (divides by 1000) -> 0.98
norm_decimal(c(10, 500, 980))
#> [1] 0.01 0.50 0.98

# Works with negative numbers
norm_decimal(c(-50, 50, 200))
#> [1] -0.05  0.05  0.20
```
