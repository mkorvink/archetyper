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

#' generates a set of files and directories to support both the data mining work-flow and surrounding technical components.
#'
#' @param project_name The name of the project to be generated.
#' @param db_connection_type A optional string indicating if a "JDBC" or "ODBC" connection will be used in the project.
#' @param exclude A character vector of components to exclude from generation. Options include: "api", "config", "gitignore", "integrate", "lint", "mediator", "readme", "test", "utilities"
#' @param path The path where the project should be created. Default is the current working directory.

#' @examples
#' generate("majestic_12")
#' @export
generate <- function(project_name,
                     db_connection_type = "", #= c("jdbc", "odbc"),
                     exclude = as.character(),
                     path = ".") {

  is_jdbc <- F
  is_odbc <- F
  if (!is_valid_project_name(project_name)){
    stop(stringr::str_c("Project name: ", project_name , " is invalid"))
  }

  project_directory <- stringr::str_c(path, "/", project_name)
  project_r_directory <- stringr::str_c(project_directory, "/R")
  if (dir.exists(project_directory)){
    stop(stringr::str_c("Project name: ", project_name , " already exists in directory ", project_directory))
  }

  directory_vect <- c("data_input/", "data_working/", "data_output/", "models/", "docs/", "drivers/", "R/")
  dir.create(project_directory)

  if (db_connection_type == "jdbc"){
    is_jdbc <- TRUE
  }

  if (db_connection_type == "odbc"){
    is_odbc <- TRUE
  }

  for (directory in directory_vect){
    if (directory == "drivers/" ){
      if (is_jdbc){
        dir.create(stringr::str_c(project_directory, "/", directory))
      }
    } else {
      dir.create(stringr::str_c(project_directory, "/", directory))
    }
  }

  common_template <-  stringr::str_replace_all(common_template, "archetyper_proj_name", {{ project_name }})

  template_vect <- c(test_template, integrate_template, enrich_template, model_template, evaluate_template, present_template,common_template,
    mediator_template, utilities_template, explore_template, api_template, lint_template, gitignore_template, readme_template, config_template, proj_template)

  names(template_vect) <- c("0_test.R", "1_integrate.R", "2_enrich.R", "3_model.R", "4_evaluate.R", "5_present.Rmd", "common.R", "mediator.R", "utilities.R",
                            "explore.R", "api.R", "lint.R", ".gitignore", "readme.md", "config.yml", stringr::str_c(project_name, ".Rproj"))

  for (template_index in seq_along(template_vect)){
    template_name <- names(template_vect)[[template_index]]

    if (template_name == "config.yml" ){
      if (is_jdbc | is_odbc){
        write_to_directory(template_vect[[template_index]], template_name, exclude, project_directory)
      }
    } else {

      if (stringr::str_ends(template_name, "(\\.R|\\.Rmd)")){
        write_to_directory(template_vect[[template_index]], template_name, exclude, project_r_directory)
      } else {
        write_to_directory(template_vect[[template_index]], template_name, exclude, project_directory)
      }
    }
  }


}

