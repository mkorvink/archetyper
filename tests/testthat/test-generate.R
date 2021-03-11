
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

test_that("test_project_creation_expect_error", {
  test_project_name <- "my : project"
  expect_error(  generate(test_project_name, path = directory))
  ifelse(dir.exists(stringr::str_c(tempdir(), "/", test_project_name)),unlink(stringr::str_c(tempdir(), "/", test_project_name), recursive=TRUE), NA)
})


test_that("test_project_creation", {
  test_project_name <- "archetyper_test_project_1"
  directory <- tempdir()

  generate(test_project_name, path = directory)
  file_vect <- list.files(stringr::str_c(tempdir(), "/",test_project_name, "/"))
  expect_equal(length(file_vect), 8)
  r_file_vect <- list.files(stringr::str_c(tempdir(), "/",test_project_name,"/R/"))
  expect_equal(length(r_file_vect), 12)
  ifelse(dir.exists(stringr::str_c(tempdir(), "/", test_project_name)),unlink(stringr::str_c(tempdir(), "/", test_project_name), recursive=TRUE), NA)
})


test_that("test_project_creation_jdbc", {
  test_project_name <- "archetyper_test_project_jdbc"
  directory <- tempdir()
  generate(test_project_name, db_connection_type = "jdbc", path = directory)
  file_vect <- list.files(stringr::str_c(tempdir(), "/",test_project_name, "/"))
  expect_equal(length(file_vect), 11)
  r_file_vect <- list.files(stringr::str_c(tempdir(), "/",test_project_name,"/R/"))
  expect_equal(length(r_file_vect), 12)
  ifelse(dir.exists(stringr::str_c(tempdir(), "/", test_project_name)),unlink(stringr::str_c(tempdir(), "/", test_project_name), recursive=TRUE), NA)
})

test_that("test_project_creation_odbc", {
  test_project_name <- "test_project_creation_odbc"
  directory <- tempdir()

  generate(test_project_name, db_connection_type = "odbc", path = directory)
  file_vect <- list.files(stringr::str_c(tempdir(), "/",test_project_name, "/"))
  expect_equal(length(file_vect), 9)
  r_file_vect <- list.files(stringr::str_c(tempdir(), "/",test_project_name,"/R/"))
  expect_equal(length(r_file_vect), 12)
  ifelse(dir.exists(stringr::str_c(tempdir(), "/", test_project_name)),unlink(stringr::str_c(tempdir(), "/", test_project_name), recursive=TRUE), NA)
})

test_that("test_project_creation_no_api", {
  test_project_name <- "archetyper_test_project_no_api"
  directory <- tempdir()

  generate(test_project_name, exclude =  c("api.R"), path = directory)
  file_vect <- list.files(stringr::str_c(tempdir(), "/",test_project_name, "/"))
  expect_equal(length(file_vect), 8)
  r_file_vect <- list.files(stringr::str_c(tempdir(), "/",test_project_name,"/R/"))
  expect_equal(length(r_file_vect), 11)
  ifelse(dir.exists(stringr::str_c(tempdir(), "/", test_project_name)),unlink(stringr::str_c(tempdir(), "/", test_project_name), recursive=TRUE), NA)
})

test_that("test_project_creation_expect_error", {
  test_project_name <- "hospital_readmissions_demo"
  directory <- tempdir()

  generate(test_project_name, path = directory)
  expect_error(  generate(test_project_name, path = directory))
  ifelse(dir.exists(stringr::str_c(tempdir(), "/", test_project_name)),unlink(stringr::str_c(tempdir(), "/", test_project_name), recursive=TRUE), NA)
})


