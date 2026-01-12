#' @importFrom utils globalVariables

# Tell the R inspector: These variables are column names used by ggplot2,
# not undefined global variables, please ignore them.
utils::globalVariables(c("Value", "Group", "density"))
