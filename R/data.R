#' Simulated Geriatric Gait Data
#'
#' A synthetic longitudinal dataset representing daily step counts of an older adult.
#' Used to demonstrate the "Vanishing Variance" problem.
#'
#' @format A data frame with 200 rows and 2 variables:
#' \describe{
#'   \item{day}{Integer. Time index (Days 1-200).}
#'   \item{steps}{Numeric. Daily step count with habitual plateau and anomalies.}
#' }
#' @source Generated via simulation logic in data-raw/.
#' @usage data(sim_gait_data)
"sim_gait_data"
