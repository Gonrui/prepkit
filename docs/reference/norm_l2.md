# L2 Normalization (Unit Vector)

Scales the vector so that its Euclidean norm (L2 norm) is 1. This
technique is often used in text mining and high-dimensional clustering,
and is related to spatial sign prepkitocessing in robust statistics.

## Usage

``` r
norm_l2(x, na.rm = TRUE)
```

## Arguments

- x:

  A numeric vector.

- na.rm:

  Logical. Remove NAs for norm calculation? Default is `TRUE`.

## Value

A numeric vector with an L2 norm of 1.

## Details

Formula: \\x' = \frac{x}{\sqrt{\sum x^2}}\\

## References

Serneels, S., De Nages, E., & Van Espen, P. J. (2006). Spatial sign
prepkitocessing: a simple way to impart moderate robustness to
multivariate estimators. *Journal of Chemical Information and Modeling*,
46(3), 1402-1409.
[doi:10.1021/ci050498u](https://doi.org/10.1021/ci050498u)

Han, J., Kamber, M., & Pei, J. (2011). *Data mining: concepts and
techniques* (3rd ed.). Morgan Kaufmann.

## Examples

``` r
# Convert a vector to unit length
x <- c(3, 4)
norm_l2(x) # Returns c(0.6, 0.8)
#> [1] 0.6 0.8
```
