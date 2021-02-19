is_valid_project_name <- function(project_name) {
  return(stringr::str_detect(project_name, "[\\\\|\\/|:|\\<|\\>|\\|]", negate = T) & stringr::str_starts(project_name, "\\.", negate = T))
}

write_to_directory <-  function(template, file_name, exclude, project_directory) {
    if (length(exclude) > 0) {
      if (max(stringr::str_detect(file_name, exclude)) == 0) {
        readr::write_file(template,
                          stringr::str_c(project_directory, stringr::str_c("/", file_name)))
      }
    } else {
      readr::write_file(template,
                        stringr::str_c(project_directory, stringr::str_c("/", file_name)))
    }
  }

#' generates a set of files and directories to support both the data mining workflow and surrounding technical components.
#'
#' @param project_name The name of the project to be generated.
#' @param db_connection_type A optional string indicating if a "JDBC" or "ODBC" connection will be used in the project.
#' @param exclude A character vector of components to exclude from generation.

#' @examples
#' generate("majestic_12")
#' @export
generate <- function(project_name,
                     db_connection_type = "", #= c("jdbc", "odbc"),
                     #exclude = c("test", "integrate", "api","utilities", "mediator", "lint", "readme", "gitignore", "config" )
                     exclude = as.character()) {

  is_jdbc <- F
  is_odbc <- F

  if (!is_valid_project_name(project_name)){
    stop(stringr::str_c("Project name: ", project_name , " is invalid ", dir))
  }

  project_directory <- stringr::str_c(getwd(), "/", project_name)

  if (dir.exists(project_directory)){
    stop(stringr::str_c("Project name: ", project_name , " already exists in directory ", project_directory))
  }

  directory_vect <- c("data_input/", "cache/", "data_output/", "models/", "docs/", "drivers/")
  dir.create(project_directory)

  if (db_connection_type == "jdbc"){
    is_jdbc <- T
    #TODO: Add jdbc connection info
  }

  if (db_connection_type == "odbc"){
    is_odbc <- T
    #TODO: Add odbc connection info
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

  common_template <-  stringr::str_replace_all(common_template, "archityper_proj_name", {{ project_name }})

  template_vect <- c(test_template, integrate_template, enrich_template, model_template, measure_template, present_template,common_template,
    mediator_template, utilities_template, api_template, lint_template, gitignore_template, readme_template, config_template)

  names(template_vect) <- c("0_test.R", "1_integrate.R", "2_enrich.R", "3_model.R", "4_measure.R", "5_present.Rmd", "common.R", "mediator.R", "utilities.R",
    "api.R", "lint.R", ".gitignore", "readme.md", "config.yml")

  for (template_index in seq_along(template_vect)){
    template_name <- names(template_vect)[[template_index]]

    if (template_name == "config.yml" ){
      if (is_jdbc | is_odbc){
        write_to_directory(template_vect[[template_index]], template_name, exclude, project_directory)
      }
    } else {
      write_to_directory(template_vect[[template_index]], template_name, exclude, project_directory)
    }
  }


}

