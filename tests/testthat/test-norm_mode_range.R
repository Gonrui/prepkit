test_that("norm_mode_range basic logic works", {
  # Standard case: Mode is 2.
  x <- c(1, 2, 2, 2, 5)
  res <- norm_mode_range(x, tau = 0.9)

  expect_equal(res, c(-1, 0, 0, 0, 1))
})

test_that("norm_mode_range simulates geriatric anomaly detection", {
  # TMIG Scenario:
  # Routine: 3000 steps (freq=3)
  # Anomaly: 200 steps (Fall)
  # Anomaly: 5000 steps (Active)
  steps <- c(3000, 3000, 3000, 200, 5000)

  res <- norm_mode_range(steps, tau = 0.8)

  # Routine should be muted to 0
  expect_equal(res[1:3], c(0, 0, 0))
  # Fall should be -1
  expect_equal(res[4], -1)
  # Active should be 1
  expect_equal(res[5], 1)
})

test_that("norm_mode_range handles plateau mode", {
  # Mode is 2 and 3
  x <- c(2, 2, 3, 3, 10)
  res <- norm_mode_range(x, tau = 0.8)
  expect_equal(res[1:4], c(0, 0, 0, 0))
})

test_that("norm_mode_range handles flat data", {
  x <- c(5, 5, 5)
  expect_equal(norm_mode_range(x), c(0, 0, 0))
})

test_that("norm_mode_range rejects non-numeric", {
  expect_error(norm_mode_range("error"), "must be a numeric")
})


test_that("norm_mode_range triggers fallback when tau > 1", {
  # Scenario: User sets an overly strict tau (e.g., 1.5)
  # The mode is 2 (freq=2). The threshold required is >= 1.5 * 2 = 3.
  # No values satisfy this condition, so 'mode_vals' is initially empty.
  # This should trigger the fallback logic (Line 55) to pick the absolute mode.
  x <- c(1, 2, 2, 3)

  # The algorithm should run robustly even with invalid tau, instead of throwing an error
  res <- norm_mode_range(x, tau = 1.5)

  # Verify: The algorithm still correctly identifies 2 as the mode (mapped to 0)
  expect_equal(res[2], 0)      # 2 is correctly zeroed out
  expect_equal(res[1], -1)     # 1 is left tail
  expect_equal(res[4], 1)      # 3 is right tail
})

test_that("M-Score handles floating point noise with digits parameter", {
  # Scenario: High precision sensor data.
  # 10.001 and 10.002 should be treated as the SAME routine (10.0).
  x <- c(10.001, 10.002, 10.003, 2.0, 20.0)

  # Case A: Without rounding (Default NULL behavior or strict)
  # If we treated them strictly, they are all unique -> uniform distribution -> all 0.
  # But we want to test that 'digits=1' groups them.

  res <- norm_mode_range(x, digits = 1)

  # 10.001, 10.002, 10.003 should be grouped as "10.0" (Mode) -> 0
  expect_equal(res[1], 0)
  expect_equal(res[2], 0)
  expect_equal(res[3], 0)

  # 2.0 is Left Tail -> -1
  expect_equal(res[4], -1)

  # 20.0 is Right Tail -> 1
  expect_equal(res[5], 1)
})

test_that("M-Score executes the raw path when digits is NULL", {
  # Scenario: Expert user wants to disable the rounding protection explicitly.
  # This triggers the 'else' block: { x_for_mode <- x }
  x <- c(1, 2, 2, 3)

  # Explicitly pass NULL to bypass the rounding logic
  res <- norm_mode_range(x, digits = NULL)

  # Verification: The logic should still hold for clean integer data
  expect_equal(res[2], 0)      # 2 is the mode
  expect_equal(res[3], 0)
  expect_equal(res[1], -1)     # 1 is Left Tail
  expect_equal(res[4], 1)      # 3 is Right Tail
})
