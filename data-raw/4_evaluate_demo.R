##-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##  Step 4: Measure. In this step, the trained model will be applied to the testing partitions. Performance measures can be persisted and retrieved in the presentation step.   -
##-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

source("R/common.R")

library(caret)

##-------------------------------------------------------
##  Apply testing partitions to the persisted model     -
##-------------------------------------------------------
info(logger, "Getting testing data for evaluation...")

testing_df <- read_feather(get_versioned_file_name("data_working", "enriched", ".feather")) %>%
  filter(!training_ind) %>%
  dplyr::select(-training_ind, -rowname)

info(logger, "Getting predictions for testing data...")

mod <- readRDS(get_versioned_file_name("models", "readmissions", ".mod"))
testing_df <- testing_df %>% cbind(prediction = predict(mod, testing_df, type = "response")) %>% tibble()

##----------------------------------------------------------------------------------------------
##  Write scored results to /data_output directory with version-controlled naming convention   -
##----------------------------------------------------------------------------------------------
info(logger, "Writing test data with predictions to /data_output directory...")

testing_df %>% write_csv(get_versioned_file_name("data_output", "testing_w_predictions", ".csv"))

##---------------------------------------------------------------------------------
##  Write performance statistics using holdout data-set to the /data_working directory   -
##---------------------------------------------------------------------------------
info(logger, "Writing miscellaneous performance results to /data_output directory...")

perf_df <- tibble(metric = "RMSE", rmse = RMSE(testing_df$prediction, testing_df$response))
perf_df %>% write_csv(get_versioned_file_name("data_output", "holdout_perf_stats", ".csv"))
