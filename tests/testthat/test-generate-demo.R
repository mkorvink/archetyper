test_that("test_demo_creation", {
  test_project_name <- "hospital_readmissions_demo"
  ifelse(dir.exists(stringr::str_c(tempdir(), "/", test_project_name)),unlink(stringr::str_c(tempdir(), "/", test_project_name), recursive=TRUE), NA)
  directory <- tempdir()
  generate_demo(path = directory)
  file_vect <- list.files(stringr::str_c(tempdir(), "/",test_project_name, "/"))
  expect_equal(length(file_vect), 8)
  r_file_vect <- list.files(stringr::str_c(tempdir(), "/",test_project_name,"/R/"))
  expect_equal(length(r_file_vect), 12)
  ifelse(dir.exists(stringr::str_c(tempdir(), "/", test_project_name)),unlink(stringr::str_c(tempdir(), "/", test_project_name), recursive=TRUE), NA)
})

test_that("test_demo_creation_expect_error", {
  test_project_name <- "hospital_readmissions_demo"
  ifelse(dir.exists(stringr::str_c(tempdir(), "/", test_project_name)),unlink(stringr::str_c(tempdir(), "/", test_project_name), recursive=TRUE), NA)
  directory <- tempdir()
  generate_demo(path = directory)
expect_error(generate_demo(path = directory))
ifelse(dir.exists(stringr::str_c(tempdir(), "/", test_project_name)),unlink(stringr::str_c(tempdir(), "/", test_project_name), recursive=TRUE), NA)
})

