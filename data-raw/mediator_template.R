
#Build this out a bit and test
tryCatch(
  {
    info(logger, "loading common libraries and constants...")
    source("0_common.R")
    info(logger, "running tests...")
    source("0_test.R")
    info(logger, "gathering and integrating data...")
    source("1_integrate.R")
    info(logger, "enriching base data...")
    source("2_enrich.R")
    info(logger, "building model(s)...")
    source("3_model.R")
    info(logger, "applying model(s) to test partitions...")
    source("4_measure.R")
    info(logger, "building presentation materials...")
    rmarkdown::render("5_present.Rmd", "pdf_document", output_dir = "docs")
    info(logger, "worflow is complete.")

  },
  error=function(cond) {
    log4r::error(logger, str_c("Script error: ",cond))
  }
)
