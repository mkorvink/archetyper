##----------------------------------------------------------------------
##  The mediator file will execute the linear data mining work-flow.   -
##----------------------------------------------------------------------

source("R/common.R")
tryCatch({
    info(logger, "running tests...")
    source("R/0_test.R")
    info(logger, "gathering and integrating data...")
    source("R/1_integrate.R")
    info(logger, "enriching base data...")
    source("R/2_enrich.R")
    info(logger, "building model(s)...")
    source("R/3_model.R")
    info(logger, "applying model(s) to test partitions...")
    source("R/4_evaluate.R")
    info(logger, "building presentation materials...")
    rmarkdown::render("R/5_present.Rmd", "pdf_document", output_dir = "docs")
    info(logger, "worflow is complete.")

  },
  error = function(cond) {
    log4r::error(logger, str_c("Script error: ", cond))
  }
)
