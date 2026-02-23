#' QC-enabling: derive window/segment indices (no assessment)
#'
#' This function does NOT evaluate quality. It only derives window indices
#' to enable downstream QC assessment at different granularities.
#'
#' @param bundle qc_bundle
#' @param time_col Name of timestamp column in `bundle$raw`.
#' @param unit One of "session" or "day".
#' @param window_secs Window length in seconds. If NULL, uses whole session (unit="session").
#' @param tz Time zone for day boundary. If NULL, uses meta$tz if present; otherwise "UTC".
#' @return Updated qc_bundle
#' @export
qc_enable_window <- function(bundle,
                             time_col = "time",
                             unit = c("session", "day"),
                             window_secs = NULL,
                             tz = NULL) {
  stopifnot(inherits(bundle, "qc_bundle"))
  unit <- match.arg(unit)

  raw <- bundle$raw
  if (!is.data.frame(raw)) {
    stop("`bundle$raw` must be a data.frame-like object for qc_enable_window().", call. = FALSE)
  }
  if (!time_col %in% names(raw)) {
    win_derived <- list(exists = FALSE, time_col = time_col, unit = unit)
    bundle <- qc_set(bundle, "qc_enable", "derived",
                     modifyList(bundle$derived, list(window = win_derived)))
    bundle <- qc_log_event(bundle, "qc_enable", "qc_enable_window",
                           params = list(time_col = time_col, unit = unit, window_secs = window_secs),
                           note = "time column not found; window not derived")
    return(bundle)
  }

  # tz: explicit > meta$tz > UTC
  if (is.null(tz)) {
    if (is.list(bundle$meta) && "tz" %in% names(bundle$meta) && length(bundle$meta$tz) == 1) {
      tz <- bundle$meta$tz
    } else {
      tz <- "UTC"
    }
  }

  t <- raw[[time_col]]

  # Convert timestamps to POSIXct for consistent day/window logic (without modifying raw)
  t_posix <- NULL
  if (inherits(t, "POSIXt")) {
    t_posix <- as.POSIXct(t, tz = tz)
  } else if (inherits(t, "Date")) {
    # Date -> midnight at tz
    t_posix <- as.POSIXct(t, tz = tz)
  } else if (is.numeric(t) || is.integer(t)) {
    # numeric treated as seconds since epoch
    t_posix <- as.POSIXct(as.numeric(t), origin = "1970-01-01", tz = tz)
  } else {
    # try coercion; if fails -> NA
    t_posix <- suppressWarnings(as.POSIXct(t, tz = tz))
  }

  # NAs remain NAs; we still create window_id with NA
  n <- length(t_posix)

  # Helper: compute window_id per row
  window_id <- rep(NA_character_, n)

  # We only assign ids for non-NA times
  ok <- !is.na(t_posix)
  t_ok <- t_posix[ok]

  # Case A: unit == "session"
  if (unit == "session") {
    if (is.null(window_secs)) {
      # Single window for the whole session
      window_id[ok] <- "session_001"
      windows <- data.frame(
        window_id = "session_001",
        start = min(t_ok),
        end = max(t_ok),
        n_rows = sum(ok),
        stringsAsFactors = FALSE
      )
    } else {
      ws <- as.numeric(window_secs)
      if (!is.finite(ws) || ws <= 0) stop("`window_secs` must be a positive number.", call. = FALSE)

      t0 <- min(t_ok)
      # integer window index starting at 1
      w_idx <- floor(as.numeric(difftime(t_ok, t0, units = "secs")) / ws) + 1L
      window_id_ok <- sprintf("win_%05d", w_idx)
      window_id[ok] <- window_id_ok

      # Summarize windows
      df <- data.frame(window_id = window_id_ok, time = t_ok, stringsAsFactors = FALSE)
      windows <- aggregate(time ~ window_id, df, function(x) c(min = min(x), max = max(x), n = length(x)))
      # unpack
      windows <- transform(
        windows,
        start = as.POSIXct(time[, "min"], origin = "1970-01-01", tz = tz),
        end = as.POSIXct(time[, "max"], origin = "1970-01-01", tz = tz),
        n_rows = as.integer(time[, "n"])
      )
      windows$time <- NULL
      windows <- windows[order(windows$window_id), ]
      rownames(windows) <- NULL
    }
  }

  # Case B: unit == "day"
  if (unit == "day") {
    # define day boundary by tz
    day_str <- format(t_ok, "%Y-%m-%d", tz = tz)
    if (is.null(window_secs)) {
      # one window per day
      window_id_ok <- paste0("day_", day_str, "_001")
      window_id[ok] <- window_id_ok

      df <- data.frame(window_id = window_id_ok, time = t_ok, stringsAsFactors = FALSE)
      windows <- aggregate(time ~ window_id, df, function(x) c(min = min(x), max = max(x), n = length(x)))
      windows <- transform(
        windows,
        start = as.POSIXct(time[, "min"], origin = "1970-01-01", tz = tz),
        end = as.POSIXct(time[, "max"], origin = "1970-01-01", tz = tz),
        n_rows = as.integer(time[, "n"])
      )
      windows$time <- NULL
      windows <- windows[order(windows$window_id), ]
      rownames(windows) <- NULL
    } else {
      ws <- as.numeric(window_secs)
      if (!is.finite(ws) || ws <= 0) stop("`window_secs` must be a positive number.", call. = FALSE)

      # within-day windows: anchor at each day's midnight
      day0 <- as.POSIXct(paste0(day_str, " 00:00:00"), tz = tz)
      w_idx <- floor(as.numeric(difftime(t_ok, day0, units = "secs")) / ws) + 1L
      window_id_ok <- sprintf("day_%s_%03d", day_str, w_idx)
      window_id[ok] <- window_id_ok

      df <- data.frame(window_id = window_id_ok, time = t_ok, stringsAsFactors = FALSE)
      windows <- aggregate(time ~ window_id, df, function(x) c(min = min(x), max = max(x), n = length(x)))
      windows <- transform(
        windows,
        start = as.POSIXct(time[, "min"], origin = "1970-01-01", tz = tz),
        end = as.POSIXct(time[, "max"], origin = "1970-01-01", tz = tz),
        n_rows = as.integer(time[, "n"])
      )
      windows$time <- NULL
      windows <- windows[order(windows$window_id), ]
      rownames(windows) <- NULL
    }
  }

  win_derived <- list(
    exists = TRUE,
    time_col = time_col,
    unit = unit,
    window_secs = window_secs,
    tz = tz,
    window_id = window_id,  # length == nrow(raw)
    windows = windows       # summary table
  )

  # IMPORTANT: do not overwrite other derived modules
  bundle <- qc_set(bundle, "qc_enable", "derived",
                   modifyList(bundle$derived, list(window = win_derived)))

  bundle <- qc_log_event(
    bundle, "qc_enable", "qc_enable_window",
    params = list(time_col = time_col, unit = unit, window_secs = window_secs, tz = tz, n = n),
    note = "derived window indices"
  )

  bundle
}
