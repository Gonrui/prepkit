#' Min-Max Normalization
#'
#' @description
#' Linearly scales a numeric vector to a specific range, typically [0, 1].
#' This method preserves the relationships among the original data values.
#'
#' @details
#' Min-max normalization performs a linear transformation on the original data.
#' The formula is given by:
#' \deqn{x' = \frac{x - min(x)}{max(x) - min(x)} \times (new\_max - new\_min) + new\_min}
#'
#' where \eqn{x} is the original value, \eqn{x'} is the normalized value.
#'
#' @param x A numeric vector to be normalized.
#' @param min_val The lower bound of the target range. Default is 0.
#' @param max_val The upper bound of the target range. Default is 1.
#' @param na.rm Logical. Should missing values (NA) be removed for the calculation of
#'   min/max? Default is \code{TRUE}.
#'
#' @return A numeric vector of the same length as \code{x}, scaled to the range
#'   [\code{min_val}, \code{max_val}].
#'
#' @references
#' Han, J., Kamber, M., & Pei, J. (2011). Data Mining: Concepts and Techniques (3rd ed.).
#' Morgan Kaufmann. Section 3.4.1.
#'
#' @export
#'
#' @examples
#' # Standard scaling to [0, 1]
#' v <- c(10, 20, 30, 40, 50)
#' norm_minmax(v)
#'
#' # Scaling to [-1, 1]
#' norm_minmax(v, min_val = -1, max_val = 1)
#'
#' # Handling NAs
#' v_na <- c(10, NA, 30, 40, 50)
#' norm_minmax(v_na, na.rm = TRUE)
norm_minmax <- function(x, min_val = 0, max_val = 1, na.rm = TRUE) {

  # --- 1. Input Validation ---

  # Ensure input x is a numeric vector
  if (!is.numeric(x)) {
    stop("Error: Input 'x' must be a numeric vector.")
  }

  # Ensure the target range is valid
  if (min_val >= max_val) {
    stop("Error: 'min_val' must be strictly less than 'max_val'.")
  }

  # --- 2. Calculate Statistics ---

  # Compute global min and max of the input vector
  # Using range() is more efficient than calling min() and max() separately
  rng <- range(x, na.rm = na.rm)
  x_min <- rng[1]
  x_max <- rng[2]

  # --- 3. Handle Edge Case: Zero Variance ---

  # If all values are identical (min == max), division by zero would occur.
  # In this case, we return the lower bound (min_val) for all elements.
  if (x_min == x_max) {
    warning("Warning: All values in 'x' are identical. Returning 'min_val' to avoid division by zero.")
    # Create a result vector filled with min_val, preserving NAs from original input
    res <- rep(min_val, length(x))
    res[is.na(x)] <- NA
    return(res)
  }

  # --- 4. Core Normalization Logic ---

  # Step A: Standardize to [0, 1]
  x_std <- (x - x_min) / (x_max - x_min)

  # Step B: Scale to [min_val, max_val]
  x_scaled <- x_std * (max_val - min_val) + min_val

  return(x_scaled)
}
