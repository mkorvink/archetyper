source("0_common.R")
library(testthat)


# Testing common functions-----------------------------------
test_that("test rounding", {
  expect_equal(round(pi, 3), 3.142)
})

# Testing integration functions-----------------------------------

# Testing munging functions-----------------------------------
