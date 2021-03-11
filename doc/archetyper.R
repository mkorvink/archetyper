## ----setup--------------------------------------------------------------------
library(archetyper)

## ---- eval=TRUE, include=FALSE, message=FALSE, warning=FALSE------------------
if(dir.exists("majestic_12")){
  unlink("majestic_12", recursive=TRUE) 
}

## ---- eval=FALSE, include=TRUE, message=FALSE, warning=FALSE------------------
#  generate("majestic_12")
#  
#  list.files("majestic_12")
#  [1] "data_input"        "data_output"       "data_working"      "docs"              "majestic_12.Rproj"
#  [6] "models"            "R"                 "readme.md"      ".gitignore"

## ---- eval=FALSE, include=TRUE, message=FALSE, warning=FALSE------------------
#  list.files("majestic_12/R/")
#  
#   [1] "0_test.R"      "1_integrate.R" "2_enrich.R"    "3_model.R"
#   [5] "4_evaluate.R"  "5_present.Rmd" "api.R"         "common.R"
#   [9] "explore.R"     "lint.R"        "mediator.R"    "utilities.R"

## ---- eval=FALSE, include=TRUE, message=FALSE, warning=FALSE------------------
#  library(odbc)
#  con <- dbConnect(odbc::odbc(), "dev_database")
#  sql <- "select my_value from my_table"
#  result_df <- dbGetQuery(con, sql)

## ---- eval=FALSE, include=TRUE, message=FALSE, warning=FALSE------------------
#  library(RJDBC)
#  db_credentials <- config::get("dev_database")
#  drv <- RJDBC::JDBC(driverClass = db_credentials$driver_class, classPath =  Sys.glob("drivers/*"))
#  con <- dbConnect(drv,db_credentials$connection_string, db_credentials$username, db_credentials$password)
#  sql <- "select my_value from my_table"
#  result_df <- dbGetQuery(con, sql)

## ---- eval=TRUE, include=FALSE, message=FALSE, warning=FALSE------------------
if(dir.exists("majestic_12")){
  unlink("majestic_12", recursive=TRUE) 
}

## ---- eval=FALSE, include=TRUE, message=FALSE, warning=FALSE------------------
#  generate("majestic_12", db_connection_type = 'jdbc')
#  list.files(project_path)
#  
#   [1] "config.yml"        "data_input"        "data_output"
#   [4] "data_working"      "docs"              "drivers"
#   [7] "majestic_12.Rproj" "models"            "R"
#  [10] "readme.md"         ".gitignore"        "dml_ddl.sql"
#  

## ---- eval=TRUE, include=FALSE, message=FALSE, warning=FALSE------------------
if(dir.exists("majestic_12")){
  unlink("majestic_12", recursive=TRUE) 
}

## ---- eval=FALSE, include=TRUE------------------------------------------------
#  generate(project_name = project_name, path = project_directory, exclude = c("api.R", "utilities.R", "readme.md", "lint.R", ".gitignore"))
#  
#  list.files(project_path)
#  [1] "data_input"        "data_output"       "data_working"      "docs"              "majestic_12.Rproj"
#  [6] "models"            "R"
#  list.files(project_path_r)
#   [1] "0_test.R"      "1_integrate.R" "2_enrich.R"    "3_model.R"     "4_evaluate.R"  "5_present.Rmd"
#   [7] "common.R"      "explore.R"     "mediator.R"

## ---- eval=TRUE, include=FALSE, message=FALSE, warning=FALSE------------------
if(dir.exists("majestic_12")){
  unlink("majestic_12", recursive=TRUE) 
}
if(dir.exists("hospital_readmissions_demo")){
  unlink("hospital_readmissions_demo", recursive=TRUE) 
}

## ---- eval=FALSE, include=TRUE------------------------------------------------
#  archetyper::generate_demo()
#  list.files("hospital_readmissions_demo/")
#  [1] "data_input"        "data_output"       "data_working"      "docs"              "hospital_readmissions_demo.Rproj"
#  [6] "models"            "R"                 "readme.md"        ".gitignore"

## ---- eval=FALSE, include=TRUE, message=FALSE, warning=FALSE------------------
#  cat(readChar("hospital_readmissions_demo/R/mediator.R"), 1e5))
#  
#  ##--------------------------------------------------------------------------
#  ##  The mediator file will execute the linear data processing work-flow.   -
#  ##--------------------------------------------------------------------------
#  
#  source("R/common.R")
#  tryCatch({
#      info(logger, "running tests...")
#      source("R/0_test.R")
#      info(logger, "gathering and integrating data...")
#      source("R/1_integrate.R")
#      info(logger, "enriching base data...")
#      source("R/2_enrich.R")
#      info(logger, "building model(s)...")
#      source("R/3_model.R")
#      info(logger, "applying model(s) to test partitions...")
#      source("R/4_evaluate.R")
#      info(logger, "building presentation materials...")
#      rmarkdown::render("R/5_present.Rmd", "pdf_document", output_dir = "docs")
#      info(logger, "workflow is complete.")
#  
#    },
#    error = function(cond) {
#      log4r::error(logger, str_c("Script error: ", cond))
#    }
#  )

## ---- eval=FALSE, message=FALSE, warning=FALSE, include=T---------------------
#  > list.files("data_working/")
#  [1] "hospital_readmissions_integrated_2021-02-25.feather"

## ---- eval=FALSE, message=FALSE, warning=FALSE, include=T---------------------
#  > list.files("data_working/")
#  [1] "hospital_readmissions_enriched_2021-02-25.feather"       "hospital_readmissions_integrated_2021-02-25.feather"

## ---- eval=FALSE, message=FALSE, warning=FALSE, include=T---------------------
#  > list.files("data_ouput/")
#  [1] "hospital_readmissions_feature_dtl_2021-02-25.csv"   "hospital_readmissions_perf_2021-02-25.csv"
#  
#  > list.files("mod/")
#  [1] "hospital_readmissions_readmissions_2021-02-23.mod"

## ---- eval=FALSE, message=FALSE, warning=FALSE, include=T---------------------
#  > list.files("data_ouput/")
#  [1] "hospital_readmissions_feature_dtl_2021-02-25.csv"   "hospital_readmissions_holdout_perf_stats_2021-02-25.csv"
#  [3] "hospital_readmissions_perf_2021-02-25.csv"    "hospital_readmissions_testing_w_predictions_2021-02-25.csv"

## ---- eval=FALSE, message=FALSE, warning=FALSE, include=T---------------------
#  #Present
#  > list.files("hospital_readmissions_demo/docs/")
#  [1] "5_present.pdf"

## ---- eval=F, message=FALSE, warning=FALSE, include=T-------------------------
#  {
#    "dt": {"state": "AL",
#      "hospital_type": "acute_care_hospitals",
#      "hospital_ownership": "government_hospital_district_or_authority",
#      "emergency_services": "Yes",
#      "ehr_interop": "Y",
#      "denominator": 1.4791,
#      "PSI_10": -1.3895,
#      "PSI_11": 0.597,
#      "PSI_12": -0.9487,
#      "PSI_13": -0.102,
#      "PSI_14": -1.1131,
#      "PSI_15": -0.9439,
#      "PSI_3": 0.029,
#      "PSI_6": -0.5752,
#      "PSI_8": -1.4081,
#      "PSI_9": -0.3028,
#      "denominator_ln": 1.3489}
#  }

