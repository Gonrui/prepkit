#' M-Score (Mode-Range Normalization)
#'
#' A robust normalization method designed for longitudinal behavioral data with a "routine plateau".
#' Also known as Mode-Range Normalization (MRN).
#'
#' @description
#' Unlike Z-Score or Min-Max, the M-Score algorithm identifies the "Mode Range" (the most frequent value range)
#' and maps it to 0. This effectively suppresses the noise of daily routine (e.g., stable step counts)
#' and amplifies anomalies (e.g., frailty or sudden activity).
#'
#' It maps:
#' \itemize{
#'   \item \strong{Mode Range}: \eqn{[k_L, k_R] \to 0} (Baseline/Routine)
#'   \item \strong{Left Tail}: \eqn{[min, k_L) \to [-1, 0)} (Decline/Frailty)
#'   \item \strong{Right Tail}: \eqn{(k_R, max] \to (0, 1]} (Surge/Hyperactivity)
#' }
#'
#' @param x A numeric vector.
#' @param tau A numeric value (0 to 1). The threshold ratio for defining the mode plateau.
#'   Bins with \code{freq >= tau * max_freq} are considered part of the routine. Default is 0.8.
#' @param digits Integer or NULL.
#'   If not NULL, values are rounded to this many decimal places \strong{solely for identifying the mode}.
#'   This makes the algorithm robust against sensor noise (e.g., 1.0001 vs 1.0002).
#'   Default is 0 (rounds to integer), which is ideal for step counts or heart rates.
#'   Set to \code{NULL} to disable rounding.
#'
#' @return A numeric vector in the range [-1, 1].
#'
#' @references
#' Gong, R. (2026). M-Score: A Robust Normalization Method for Detecting Anomalies in Longitudinal Behavioral Data.
#' \emph{arXiv preprint}. (Submitted)
#'
#' @export
#'
#' @examples
#' # Scenario 1: Integer data (Standard)
#' steps <- c(3000, 3000, 200, 5000)
#' norm_mode_range(steps)
#'
#' # Scenario 2: Noisy Sensor Data (Floating point)
#' # Without 'digits', these would be seen as different values.
#' # With digits=1, they are grouped into the same mode.
#' sensor_data <- c(9.81, 9.82, 9.80, 2.5, 15.0)
#' norm_mode_range(sensor_data, digits = 1)
norm_mode_range <- function(x, tau = 0.8, digits = 0) {
  # 1. Input Validation
  if (!is.numeric(x)) stop("Input 'x' must be a numeric vector.")

  # 2. Edge Case: Flat data
  rng <- range(x, na.rm = TRUE)
  if (rng[1] == rng[2]) return(rep(0, length(x)))

  # 3. Identify Mode Range (The "Routine Plateau")
  # PROTECTION SHELL: Round data for mode detection if digits is set
  if (!is.null(digits)) {
    x_for_mode <- round(x, digits)
  } else {
    x_for_mode <- x
  }

  tab <- table(x_for_mode)
  f_max <- max(tab)

  # Select values that appear frequently enough
  # Note: names(tab) are strings, we convert them back to numeric
  mode_vals <- as.numeric(names(tab)[tab >= tau * f_max])

  # Defensive fallback
  if (length(mode_vals) == 0) {
    mode_vals <- as.numeric(names(tab)[which.max(tab)])
  }

  k_L <- min(mode_vals)
  k_R <- max(mode_vals)
  k_min <- rng[1]
  k_max <- rng[2]

  # 4. Define Ranges (with epsilon protection)
  eps <- .Machine$double.eps
  L_range <- max(k_L - k_min, eps)
  R_range <- max(k_max - k_R, eps)

  # 5. Apply Transformation (Using ORIGINAL x)
  res <- numeric(length(x))

  # CRITICAL FIX: Use 'x_for_mode' to determine classification (Left/Right/Mode)
  # But keep using original 'x' for the calculation to preserve precision.

  # Left Tail
  idx_left <- x_for_mode < k_L
  if (any(idx_left)) {
    res[idx_left] <- - (k_L - x[idx_left]) / L_range
  }

  # Right Tail
  idx_right <- x_for_mode > k_R
  if (any(idx_right)) {
    res[idx_right] <- (x[idx_right] - k_R) / R_range
  }

  # Mode Range is implicitly 0 (initialized)
  # Any value where (x_for_mode >= k_L & x_for_mode <= k_R) remains 0.

  return(res)
}
