#' QC-enabling: derive per-window structure stats (no assessment)
#'
#' Requires `derived$window` from `qc_enable_window()`.
#' This function does NOT evaluate quality and does NOT write metrics/flags/decision.
#'
#' @param bundle qc_bundle
#' @param time_col Name of timestamp column in `bundle$raw`.
#' @param tz Time zone used for POSIXct conversion (if needed). If NULL, uses meta$tz or "UTC".
#' @return Updated qc_bundle
#' @export
qc_enable_window_stats <- function(bundle, time_col = "time", tz = NULL) {
  stopifnot(inherits(bundle, "qc_bundle"))

  # Preconditions
  if (!is.list(bundle$derived) || is.null(bundle$derived$window) || !isTRUE(bundle$derived$window$exists)) {
    stop("`derived$window` not found. Run qc_enable_window() first.", call. = FALSE)
  }

  raw <- bundle$raw
  if (!is.data.frame(raw)) {
    stop("`bundle$raw` must be a data.frame-like object for qc_enable_window_stats().", call. = FALSE)
  }
  if (!time_col %in% names(raw)) {
    stop("time_col not found in raw: ", time_col, call. = FALSE)
  }

  # tz: explicit > meta$tz > derived$window$tz > UTC
  if (is.null(tz)) {
    if (is.list(bundle$meta) && "tz" %in% names(bundle$meta) && length(bundle$meta$tz) == 1) {
      tz <- bundle$meta$tz
    } else if (!is.null(bundle$derived$window$tz) && length(bundle$derived$window$tz) == 1) {
      tz <- bundle$derived$window$tz
    } else {
      tz <- "UTC"
    }
  }

  win <- bundle$derived$window
  window_id <- win$window_id
  if (length(window_id) != nrow(raw)) {
    stop("Invalid derived$window: window_id length must equal nrow(raw).", call. = FALSE)
  }

  # Local time conversion (do not modify raw)
  t <- raw[[time_col]]
  if (inherits(t, "POSIXt")) {
    t_posix <- as.POSIXct(t, tz = tz)
  } else if (inherits(t, "Date")) {
    t_posix <- as.POSIXct(t, tz = tz)
  } else if (is.numeric(t) || is.integer(t)) {
    t_posix <- as.POSIXct(as.numeric(t), origin = "1970-01-01", tz = tz)
  } else {
    t_posix <- suppressWarnings(as.POSIXct(t, tz = tz))
  }

  windows_tbl <- win$windows
  if (!is.data.frame(windows_tbl) || !"window_id" %in% names(windows_tbl)) {
    stop("Invalid derived$window$windows table.", call. = FALSE)
  }

  # Helper: dt summary within a vector of POSIXct times
  dt_summary_one <- function(tt) {
    tt <- tt[!is.na(tt)]
    if (length(tt) <= 1) {
      return(list(dt_n = 0L, dt_min = NA_real_, dt_median = NA_real_, dt_max = NA_real_))
    }
    tt <- sort(tt)
    dt <- as.numeric(diff(tt), units = "secs")
    list(
      dt_n = length(dt),
      dt_min = min(dt),
      dt_median = stats::median(dt),
      dt_max = max(dt)
    )
  }

  # Compute per-window stats (loop is fine: number of windows << rows)
  w_ids <- as.character(windows_tbl$window_id)
  out <- vector("list", length(w_ids))

  for (i in seq_along(w_ids)) {
    wid <- w_ids[i]
    idx <- which(window_id == wid)

    tt <- t_posix[idx]
    na_time_n <- sum(is.na(tt))
    tt_non_na <- tt[!is.na(tt)]
    unique_time_n <- length(unique(tt_non_na))

    start <- if (length(tt_non_na) == 0) as.POSIXct(NA, tz = tz) else min(tt_non_na)
    end <- if (length(tt_non_na) == 0) as.POSIXct(NA, tz = tz) else max(tt_non_na)
    span_secs <- if (is.na(start) || is.na(end)) NA_real_ else as.numeric(difftime(end, start, units = "secs"))

    dts <- dt_summary_one(tt_non_na)

    out[[i]] <- data.frame(
      window_id = wid,
      n_rows = length(idx),
      na_time_n = na_time_n,
      unique_time_n = unique_time_n,
      start = start,
      end = end,
      span_secs = span_secs,
      dt_n = dts$dt_n,
      dt_min = dts$dt_min,
      dt_median = dts$dt_median,
      dt_max = dts$dt_max,
      stringsAsFactors = FALSE
    )
  }

  stats_tbl <- do.call(rbind, out)
  rownames(stats_tbl) <- NULL

  # Write derived$window_stats (do not overwrite other derived modules)
  bundle <- qc_set(bundle, "qc_enable", "derived",
                   modifyList(bundle$derived, list(window_stats = stats_tbl)))

  bundle <- qc_log_event(
    bundle, "qc_enable", "qc_enable_window_stats",
    params = list(time_col = time_col, tz = tz, n_windows = nrow(stats_tbl), n_rows = nrow(raw)),
    note = "derived per-window structure stats"
  )

  bundle
}
