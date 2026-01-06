test_that("norm_zscore works on standard input", {
  x <- 1:5
  res <- norm_zscore(x)

  # Verify statistical properties: mean should be 0, sd should be 1
  expect_equal(mean(res), 0)
  expect_equal(sd(res), 1)

  # Manual verification for the first element
  expected_first_val <- (1 - mean(x)) / sd(x)
  expect_equal(res[1], expected_first_val)
})

test_that("norm_zscore handles Zero Variance (Edge Case)", {
  x <- c(5, 5, 5)
  # Expect a warning when standard deviation is zero
  expect_warning(res <- norm_zscore(x), "Standard deviation is zero")
  # Expect the result to be a vector of zeros
  expect_equal(res, c(0, 0, 0))
})

test_that("norm_zscore handles NA values properly", {
  x <- c(1, 2, 3, NA)

  # Case 1: Remove NA (Default)
  res <- norm_zscore(x, na.rm = TRUE)
  expect_true(is.na(res[4])) # The 4th element should remain NA
  expect_equal(mean(res, na.rm = TRUE), 0) # The mean of remaining numbers should be 0

  # Case 2: Zero variance with NA present (e.g., c(5, 5, NA))
  expect_warning(res_edge <- norm_zscore(c(5, 5, NA)), "Standard deviation is zero")
  expect_equal(res_edge[1:2], c(0, 0))
  expect_true(is.na(res_edge[3]))
})

test_that("norm_zscore checks input types", {
  expect_error(norm_zscore("invalid"), "must be a numeric vector")
})
