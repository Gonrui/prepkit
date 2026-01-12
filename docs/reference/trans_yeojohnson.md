# Yeo-Johnson Transformation

A power transformation similar to Box-Cox but supports both positive and
negative values. Automatically estimates the optimal lambda using MLE.

## Usage

``` r
trans_yeojohnson(x, lambda = "auto")
```

## Arguments

- x:

  A numeric vector.

- lambda:

  A numeric value or "auto".

## Value

A numeric vector with attribute "lambda".

## References

Yeo, I.-K., & Johnson, R. A. (2000). A new family of power
transformations to improve normality or symmetry. Biometrika.
