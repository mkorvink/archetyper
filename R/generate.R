is_valid_project_name <- function(project_name) {
  return(stringr::str_detect(project_name, "[\\\\|\\/|:|\\<|\\>|\\|]", negate = TRUE) & stringr::str_starts(project_name, "\\.", negate = TRUE))
}

write_to_directory <-  function(template, file_name, exclude, project_directory) {
    if (length(exclude) > 0) {
      if (!tolower(file_name) %in% tolower(exclude)) {
        readr::write_file(template,
                          stringr::str_c(project_directory, stringr::str_c("/", file_name)))
      }
    } else {
      readr::write_file(template,
                        stringr::str_c(project_directory, stringr::str_c("/", file_name)))
    }
  }

#' generates a set of files and directories to support both the data mining and data science workflow.
#'
#' @param project_name The name of the project to be generated.
#' @param db_connection_type A optional string indicating if a "JDBC" or "ODBC" connection will be used in the project. Options include: "jdbc" or "odbc"
#' @param exclude A character vector of components to exclude from generation. Options include: "0_test.R", "1_integrate.R", "2_enrich.R", "3_model.R", "4_evaluate.R", "5_present.Rmd", "common.R", "mediator.R", "utilities.R", "explore.R", "api.R", "lint.R", ".gitignore", "readme.md", "config.yml"
#' @param path The path where the project should be created. Default is a temporary directory: tempdir().
#' @return No return value.
#' @examples
#'\dontrun{
#' generate("majestic_12")
#'}
#' @export
generate <- function(project_name,
                     db_connection_type = "",
                     exclude = as.character(),
                     path = tempdir()) {

  if (path == tempdir()){
    print(stringr::str_c("Writing project to temporary directory: ", path))
    print("A destination directory can be specified using the 'path' argument.")
  } else {
    print(stringr::str_c("Writing project to directory: ", path))
  }

  is_jdbc <- F
  is_odbc <- F
  if (!is_valid_project_name(project_name)) {
    stop(stringr::str_c("Project name: ", project_name, " is invalid"))
  }

  project_directory <- stringr::str_c(path, "/", project_name)
  project_r_directory <- stringr::str_c(project_directory, "/R")
  if (dir.exists(project_directory)) {
    stop(stringr::str_c("Project name: ", project_name, " already exists in directory ", project_directory))
  }

  directory_vect <- c("data_input/", "data_working/", "data_output/", "models/", "docs/", "R/")
  dir.create(project_directory)

  if (db_connection_type == "jdbc") {
    integrate_template <- stringr::str_replace_all(integrate_template, "archetyper_db_token", jdbc_snippet)
    dir.create(stringr::str_c(project_directory, "/drivers/"))
    is_jdbc <- TRUE
  } else if (db_connection_type == "odbc") {
    integrate_template <- stringr::str_replace_all(integrate_template, "archetyper_db_token", odbc_snippet)
    is_odbc <- TRUE
  } else {
    integrate_template <- stringr::str_replace_all(integrate_template, "archetyper_db_token", "")
  }

  for (directory in directory_vect) {
    dir.create(stringr::str_c(project_directory, "/", directory))
  }

  common_template <-  stringr::str_replace_all(common_template, "archetyper_proj_name", {{ project_name }})

  template_vect <- c(test_template, integrate_template, enrich_template, model_template, evaluate_template, present_template, common_template,
    mediator_template, utilities_template, explore_template, api_template, lint_template, gitignore_template, readme_template, config_template, proj_template, sql_template)

  names(template_vect) <- c("0_test.R", "1_integrate.R", "2_enrich.R", "3_model.R", "4_evaluate.R", "5_present.Rmd", "common.R", "mediator.R", "utilities.R",
                            "explore.R", "api.R", "lint.R", ".gitignore", "readme.md", "config.yml", stringr::str_c(project_name, ".Rproj"), "dml_ddl.sql")

  for (template_index in seq_along(template_vect)) {
    template_name <- names(template_vect)[[template_index]]
    if (template_name == "config.yml") {
      if (is_jdbc) {
        write_to_directory(template_vect[[template_index]], template_name, exclude, project_directory)
      }
    } else if (template_name == "dml_ddl.sql") {
      if (is_jdbc | is_odbc) {
        write_to_directory(template_vect[[template_index]], template_name, exclude, project_directory)
      }
    } else {
      if (stringr::str_ends(template_name, "(\\.R|\\.Rmd)")) {
        write_to_directory(template_vect[[template_index]], template_name, exclude, project_r_directory)
      } else {
        write_to_directory(template_vect[[template_index]], template_name, exclude, project_directory)
      }
    }
  }
}
