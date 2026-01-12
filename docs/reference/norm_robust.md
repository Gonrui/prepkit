# Robust Standardization (Median-MAD)

Standardizes a numeric vector using robust statistics: median and median
absolute deviation (MAD). This method is less sensitive to outliers
compared to Z-score standardization.

## Usage

``` r
norm_robust(x, na.rm = TRUE, constant = 1.4826)
```

## Arguments

- x:

  A numeric vector.

- na.rm:

  Logical. Should NA values be removed? Default is `TRUE`.

- constant:

  A scale factor for MAD calculation. Default is 1.4826, which ensures
  consistency with the standard deviation for normal distributions.

## Value

A numeric vector. If MAD is 0 (e.g., more than 50 returns a centered
vector (x - median) and issues a warning.

## Details

Formula: \\x' = \frac{x - \text{median}(x)}{\text{mad}(x)}\\

## References

Huber, P. J. (1981). *Robust Statistics*. Wiley. ISBN:
978-0-471-41805-4.

Hampel, F. R. (1974). The influence curve and its role in robust
estimation. *Journal of the American Statistical Association*, 69(346),
383-393.

## Examples

``` r
# Data with an outlier
x <- c(1, 2, 3, 4, 100)

# Z-score is heavily affected by the outlier
norm_zscore(x)
#> [1] -0.4814564 -0.4585299 -0.4356034 -0.4126769  1.7882666

# Robust scaler handles it better
norm_robust(x)
#> [1] -1.3489815 -0.6744908  0.0000000  0.6744908 65.4256037
```
