
get_versioned_file_name <- function(directory, file_name, file_suffix, file_date = str_replace(Sys.time(), " ", "_")) {
  stringr::str_c(directory, "/", project_name, "_", file_name, "_", file_date, file_suffix)
}
