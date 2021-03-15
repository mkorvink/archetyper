write_to_dir <-
  function(demo, file_name, project_directory) {
    output_path <- stringr::str_c(project_directory, stringr::str_c("/", file_name))
    readr::write_file(demo, output_path)
  }

#' generates a demo project using archetyper
#'
#' @param path The path where the project should be created. Default is a temporary directory: tempdir().
#' @return No return value.
#' @examples
#'\dontrun{
#' generate("majestic_12")
#'}
#' @export
generate_demo <- function(path = tempdir()) {

  if (path == tempdir()){
    print(stringr::str_c("Writing project to temporary directory: ", path))
    print("A destination directory can be specified using the 'path' argument.")
  } else {
    print(stringr::str_c("Writing project to directory: ", path))
  }



  project_name <- "hospital_readmissions_demo"
  project_directory <- stringr::str_c(path, "/", project_name)
  project_r_directory <- stringr::str_c(project_directory, "/R")

  if (dir.exists(project_directory)) {
    stop(stringr::str_c("Project name: ", project_name, " already exists in directory ", project_directory))
  }

  directory_vect <- c("data_input/", "data_working/", "data_output/", "models/", "docs/", "R/")

  dir.create(project_directory)

  for (directory in directory_vect) {
      dir.create(stringr::str_c(project_directory, "/", directory))
  }

  demo_vect <- c(test_demo, integrate_demo, enrich_demo, model_demo, evaluate_demo, present_demo, common_demo,
    mediator_demo, utilities_demo, explore_demo, api_demo, lint_demo, gitignore_demo, readme_demo,  proj_demo)

  names(demo_vect) <- c("0_test.R", "1_integrate.R", "2_enrich.R", "3_model.R", "4_evaluate.R", "5_present.Rmd", "common.R", "mediator.R", "utilities.R",
                        "explore.R", "api.R", "lint.R", ".gitignore", "readme.md",  stringr::str_c(project_name, ".Rproj"))

  for (demo_index in seq_along(demo_vect)) {
    demo_name <- names(demo_vect)[[demo_index]]

    if (stringr::str_ends(demo_name, "(\\.R|\\.Rmd)")) {
      write_to_dir(demo_vect[[demo_index]], demo_name, project_r_directory)
    } else {
      write_to_dir(demo_vect[[demo_index]], demo_name, project_directory)
    }
  }
}
