library(testthat)
library(archityper)
test_check("archityper")

is_valid_project_name <- function(project_name) {
  return(stringr::str_detect(project_name, "[\\\\|\\/|:|\\<|\\>|\\|]", negate = T) & stringr::str_starts(project_name, "\\.", negate = T))
}

test_that("Testing happy path project name", {
  expect_equal(is_valid_project_name("Hello"), T)
})

test_that("Project names can include a period", {
  expect_equal(is_valid_project_name("22.891"), T)
})

test_that("Project names cannot include a /", {
  expect_equal(is_valid_project_name("my/project"), F)
})

test_that("Project names cannot include a |", {
  expect_equal(is_valid_project_name("my|project"), F)
})

test_that("Project names cannot include a >", {
  expect_equal(is_valid_project_name("my>project"), F)
})

test_that("Project names cannot include a <", {
  expect_equal(is_valid_project_name("my < project"), F)
})

test_that("Project names cannot include a :", {
  expect_equal(is_valid_project_name("my : project"), F)
})



