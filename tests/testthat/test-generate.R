
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

test_that("test_project_creation", {
  test_project_name <- "archetyper_test_project_1"
  generate(test_project_name)
  expect_equal(is_valid_project_name("my : project"), F)
  file_vect <- list.files(stringr::str_c(test_project_name, "/"))
  expect_equal(length(file_vect), 8)
  r_file_vect <- list.files(stringr::str_c(test_project_name,"/R/"))
  expect_equal(length(r_file_vect), 12)
  ifelse(dir.exists(test_project_name),unlink(test_project_name, recursive=TRUE), NA)
})
