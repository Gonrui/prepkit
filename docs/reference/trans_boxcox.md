# Box-Cox Transformation

Applies the Box-Cox transformation to normalize the data distribution.
It automatically handles non-positive values by shifting the data. The
optimal lambda parameter is estimated using Maximum Likelihood
Estimation (MLE).

## Usage

``` r
trans_boxcox(x, lambda = "auto", force_pos = TRUE)
```

## Arguments

- x:

  A numeric vector.

- lambda:

  A numeric value for the transformation power. If `"auto"` (default),
  the optimal lambda is estimated within the interval \[-2, 2\].

- force_pos:

  Logical. If `TRUE` (default), automatically shifts data to be positive
  if non-positive values are present.

## Value

A numeric vector with the transformed values. The used `lambda` and
`shift` amount are attached as attributes: `attr(res, "lambda")` and
`attr(res, "shift")`.

## References

Box, G. E. P., & Cox, D. R. (1964). An analysis of transformations.
*Journal of the Royal Statistical Society: Series B (Methodological)*,
26(2), 211-243. <https://www.jstor.org/stable/2984418>
