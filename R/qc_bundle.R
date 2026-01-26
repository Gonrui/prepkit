#' Initialize a QC bundle
#'
#' Create a `qc_bundle` object that carries raw data and QC metadata containers.
#' This function performs no QC and does not modify the raw data.
#'
#' @param data Raw data (data.frame / tibble / other).
#' @param meta A list of metadata describing `data`.
#' @return An object of class `qc_bundle`.
#' @export
qc_init <- function(data, meta = list(), validate = FALSE) {
  if (missing(data)) stop("`data` must be provided.", call. = FALSE)
  if (!is.list(meta)) stop("`meta` must be a list.", call. = FALSE)

  if (validate && !is.data.frame(data)) {
    warning(
      "`data` is not a data.frame-like object. QC functions may expect named columns.",
      call. = FALSE
    )
  }

  bundle <- list(
    raw = data,
    meta = meta,
    derived = list(),
    metrics = list(),
    flags = list(),
    decision = NULL,
    reasons = character(),
    log = qc_log_init()
  )
  class(bundle) <- c("qc_bundle", "list")

  bundle <- qc_log_add(bundle, stage = "init", fn = "qc_init", detail = "initialize qc_bundle")
  bundle
}


#' Initialize QC audit log (internal)
#'
#' @return A data.frame representing an append-only audit log.
#' @keywords internal
qc_log_init <- function() {
  data.frame(
    time = character(),
    stage = character(),
    fn = character(),
    detail = character(),
    stringsAsFactors = FALSE
  )
}


#' Append a QC log entry (internal)
#'
#' @param bundle qc_bundle
#' @param stage Stage name (e.g., "qc_enable", "qc_assess", "qc_decide").
#' @param fn Function name that produced the entry.
#' @param detail Free-form detail string (e.g., parameter summary).
#' @return Updated qc_bundle
#' @keywords internal
qc_log_add <- function(bundle, stage, fn, detail = "") {
  stopifnot(inherits(bundle, "qc_bundle"))
  entry <- data.frame(
    time = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
    stage = as.character(stage),
    fn = as.character(fn),
    detail = as.character(detail),
    stringsAsFactors = FALSE
  )
  bundle$log <- rbind(bundle$log, entry)
  bundle
}


# ---- Stage guardrails (internal) ----

#' Check whether a stage is allowed to write specific fields (internal)
#'
#' @param stage Character. One of: "init", "qc_enable", "qc_assess", "qc_decide", "post_validate".
#' @return Normalized stage name.
#' @keywords internal
qc_stage_normalize <- function(stage) {
  stage <- as.character(stage)
  allowed <- c("init", "qc_enable", "qc_assess", "qc_decide", "post_validate")
  if (!stage %in% allowed) {
    stop("Unknown stage: ", stage, call. = FALSE)
  }
  stage
}

#' Assert write permission for qc_bundle fields (internal)
#'
#' @param bundle qc_bundle
#' @param stage stage name
#' @param fields character vector of field names that are about to be written
#' @keywords internal
qc_stage_assert_write <- function(bundle, stage, fields) {
  stopifnot(inherits(bundle, "qc_bundle"))
  stage <- qc_stage_normalize(stage)
  fields <- as.character(fields)

  # Global rule: never overwrite raw after init
  if ("raw" %in% fields && stage != "init") {
    stop("Write denied: `raw` is read-only after initialization.", call. = FALSE)
  }

  # Field-level permissions by stage
  stage_allowed <- list(
    init = c("raw", "meta", "derived", "metrics", "flags", "decision", "reasons", "log"),
    qc_enable = c("derived", "meta", "log"),
    qc_assess = c("metrics", "flags", "log"),
    qc_decide = c("decision", "reasons", "log"),
    post_validate = c("log") # can extend later for processing-induced diagnostics
  )

  allowed_fields <- stage_allowed[[stage]]
  denied <- setdiff(fields, allowed_fields)
  if (length(denied) > 0) {
    stop(
      "Write denied for stage `", stage, "`: ",
      paste0("`", denied, "`", collapse = ", "),
      call. = FALSE
    )
  }

  invisible(TRUE)
}

#' Safe setter for qc_bundle fields (internal)
#'
#' @param bundle qc_bundle
#' @param stage stage name
#' @param field single field name
#' @param value value to assign
#' @return updated qc_bundle
#' @keywords internal
qc_set <- function(bundle, stage, field, value) {
  field <- as.character(field)
  qc_stage_assert_write(bundle, stage, field)
  bundle[[field]] <- value
  bundle
}


