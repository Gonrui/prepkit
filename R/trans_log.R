#' Logarithmic Transformation
#'
#' Applies a logarithmic transformation with an offset.
#' Useful for handling right-skewed data.
#'
#' @param x A numeric vector.
#' @param base A positive number. The base of the logarithm. Default is exp(1).
#' @param offset A numeric value to add before taking the log. Default is 1.
#'
#' @return A numeric vector.
#' @references
#' Bartlett, M. S. (1947). The use of transformations.
#' \emph{Biometrics}, 3(1), 39-52.
#'
#' @export
trans_log <- function(x, base = exp(1), offset = 1) {
  if (!is.numeric(x)) stop("Input 'x' must be a numeric vector.")

  # Check if offset is sufficient
  min_val <- min(x, na.rm = TRUE)

  if (min_val + offset <= 0) {
    # 1. Issue our detailed custom warnings
    warning("Negative or zero values produced after adding offset. NaNs may be generated (log of non-positive).")

    # 2. Calculation results, but suppressing R's built-in "NaNs produced" warning (because it's redundant).
    return(suppressWarnings(log(x + offset, base = base)))
  }

  # Under normal circumstances, the original warning mechanism is retained.
  return(log(x + offset, base = base))
}
