##-------------------------------------------------------------------------------------------------------------------------
##  Step 3: Modeling. In this step, the training partitions from the enrichment step are loaded and a model is trained.   -
##-------------------------------------------------------------------------------------------------------------------------

source("R/common.R")

library(broom)
library(feather)
library(performance)
library(MASS)

##---------------------------------------------------------
##          Read the training data partition(s)           -
##---------------------------------------------------------
info(logger, "Getting training data for modeling...")

training_df <- read_feather(get_versioned_file_name("data_working", "enriched", ".feather")) %>%
  filter(training_ind) %>%
  dplyr::select(-training_ind, -rowname)

##---------------------------------------------------------------
##                          Build model                         -
##---------------------------------------------------------------
info(logger, "Building base model...")

feature_vect <- training_df %>%
  dplyr::select(-response) %>%
  colnames()

formula <- as.formula(str_c("response ~ ", str_c(feature_vect, collapse = " + ")))
readmission_mod <- lm(formula, data = training_df)

info(logger, "Building stepwise model...")

readmission_mod_step <- stepAIC(readmission_mod)

##------------------------------------------------------------------------------
##  Write model coefficients, and performance statistics to /cache directory   -
##------------------------------------------------------------------------------
info(logger, "Writing model performance statistics and coefficients to /data_working directory...")

broom::glance(readmission_mod_step) %>% write_csv(get_versioned_file_name("data_output", "perf", ".csv"))
broom::tidy(readmission_mod_step, conf.int = T) %>% write_csv(get_versioned_file_name("data_output", "feature_dtl", ".csv"))

##------------------------------------
##  Write model to /model directory  -
##------------------------------------
info(logger, "Writing model to /models directory...")

saveRDS(readmission_mod_step, get_versioned_file_name("models", "readmissions", ".mod"))
