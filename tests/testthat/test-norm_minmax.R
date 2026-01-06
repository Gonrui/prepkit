test_that("Min-Max normalization works on standard input", {
  # Basic functionality test
  expect_equal(norm_minmax(c(0, 5, 10)), c(0, 0.5, 1))
  expect_equal(norm_minmax(c(-10, 0, 10)), c(0, 0.5, 1))

  # Custom range test (e.g., scaling to [-1, 1])
  res <- norm_minmax(c(0, 5, 10), min_val = -1, max_val = 1)
  expect_equal(res, c(-1, 0, 1))
})

test_that("Min-Max handles Edge Cases", {
  # Edge case: Constant vector (Zero variance)
  # When all values are identical, min == max, leading to division by zero.
  # The function should warn and return the 'min_val' (default 0).
  expect_warning(res <- norm_minmax(c(5, 5, 5)), "All values in 'x' are identical")
  expect_equal(res, c(0, 0, 0))

  # NA handling
  # By default (na.rm = TRUE), NAs should be ignored during calculation but preserved in output
  expect_equal(norm_minmax(c(0, 10, NA), na.rm = TRUE), c(0, 1, NA))
})

test_that("Min-Max catches invalid inputs", {
  # Invalid input type test
  expect_error(norm_minmax("invalid"), "must be a numeric vector")

  # Logical error test: min_val must be less than max_val
  expect_error(norm_minmax(1:5, min_val = 1, max_val = 0), "must be strictly less than")
})
