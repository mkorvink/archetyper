write_to_dir <-
  function(demo, file_name, project_directory) {
    output_path <- stringr::str_c(project_directory, stringr::str_c("/", file_name))
    print(output_path)
      readr::write_file(demo, output_path)
  }

#' generates a demo project built using the archetyper library
#'
#' @examples
#' generate_demo()
#' @export
generate_demo <- function() {

  project_name <- "hospital_readmissions_demo"
  project_directory <- stringr::str_c(getwd(), "/", project_name)

  if (dir.exists(project_directory)){
    stop(stringr::str_c("Project name: ", project_name , " already exists in directory ", project_directory))
  }

  directory_vect <- c("data_input/", "cache/", "data_output/", "models/", "docs/", "drivers/")
  dir.create(project_directory)

  for (directory in directory_vect){
      dir.create(stringr::str_c(project_directory, "/", directory))
  }

  demo_vect <- c(test_demo, integrate_demo, enrich_demo, model_demo, measure_demo, present_demo,common_demo,
    mediator_demo, utilities_demo, api_demo, lint_demo, gitignore_demo, readme_demo, config_demo)

  names(demo_vect) <- c("0_test.R", "1_integrate.R", "2_enrich.R", "3_model.R", "4_measure.R", "5_present.Rmd", "common.R", "mediator.R", "utilities.R",
    "api.R", "lint.R", ".gitignore", "readme.md", "config.yml")

  for (demo_index in seq_along(demo_vect)){
    demo_name <- names(demo_vect)[[demo_index]]
    write_to_dir(demo_vect[[demo_index]], demo_name,  project_directory)

  }

   readr::write_csv(hospital_general_demo_file, stringr::str_c(project_directory, "/data_input/Hospital_General_Information.csv"))
   readr::write_csv(complication_demo_file, stringr::str_c(project_directory, "/data_input/CMS_PSI_6_decimal_file.csv"))
   readr::write_csv(readmission_demo_file, stringr::str_c(project_directory, "/data_input/Unplanned_Hospital_Visits-Hospital.csv" ))
}
