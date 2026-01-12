# Min-Max Normalization

Scales a numeric vector to a specific range, typically \[0, 1\]. This
method is sensitive to outliers.

## Usage

``` r
norm_minmax(x, min_val = 0, max_val = 1, na.rm = TRUE)
```

## Arguments

- x:

  A numeric vector.

- min_val:

  The minimum value of the target range. Default is 0.

- max_val:

  The maximum value of the target range. Default is 1.

- na.rm:

  Logical. Should NA values be removed during min/max calculation?
  Default is `TRUE`.

## Value

A numeric vector scaled to the range \[min_val, max_val\].

## Details

Formula: \\x' = \frac{x - \min(x)}{\max(x) - \min(x)} \times
(\text{max\\val} - \text{min\\val}) + \text{min\\val}\\

## References

Han, J., Kamber, M., & Pei, J. (2011). *Data mining: concepts and
techniques* (3rd ed.). Morgan Kaufmann.

## Examples

``` r
norm_minmax(c(1, 2, 3, 4, 5))
#> [1] 0.00 0.25 0.50 0.75 1.00
norm_minmax(c(1, 2, 3), min_val = -1, max_val = 1)
#> [1] -1  0  1
```
