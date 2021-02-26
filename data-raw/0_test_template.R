##-------------------------------------------------------------------------------------------------
##  Each functional component within the work-flow should be tested in isolation using unit tests -
##-------------------------------------------------------------------------------------------------

source("R/common.R")

library(testthat)

# Testing common functions-----------------------------------
test_that("test rounding", {
  expect_equal(round(pi, 3), 3.142)
})

# Testing integration functions-----------------------------------

# Testing enrichment functions-----------------------------------

# Testing model functions-----------------------------------

# Testing measurement functions-----------------------------------
