# Logarithmic Transformation

Applies a logarithmic transformation with an offset. Useful for handling
right-skewed data.

## Usage

``` r
trans_log(x, base = exp(1), offset = 1)
```

## Arguments

- x:

  A numeric vector.

- base:

  A positive number. The base of the logarithm. Default is exp(1).

- offset:

  A numeric value to add before taking the log. Default is 1.

## Value

A numeric vector.

## References

Bartlett, M. S. (1947). The use of transformations. *Biometrics*, 3(1),
39-52.
