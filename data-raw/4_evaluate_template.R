##-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##  Step 4: Measure. In this step, the trained model will be applied to the testing partitions. Performance measures can be persisted and retrieved in the presentation step.   -
##-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

source("R/common.R")

##-------------------------------------------------------
##  Apply testing partitions to the persisted model     -
##-------------------------------------------------------

info(logger, " Apply testing partitions to the persisted model...")

#testing_df <- read_feather(get_versioned_file_name("data_working", "enriched", ".feather")) %>%
#  filter(!training_ind) %>%
#  dplyr::select(-training_ind)
#
#mod <- readRDS(get_versioned_file_name("models", "readmissions", ".mod"))
#testing_df <- testing_df %>% cbind(prediction = predict(mod, testing_df, type = "response")) %>% tibble()

##----------------------------------------------------------------------------------------------
##  Write scored results to data_output/ directory with version-controlled naming convention   -
##----------------------------------------------------------------------------------------------

#testing_df %>% write_csv(get_versioned_file_name("data_output", "testing_w_predictions", ".csv"))
