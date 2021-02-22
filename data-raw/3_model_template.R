##-------------------------------------------------------------------------------------------------------------------------
##  Step 3: Modeling. In this step, the training partitions from the enrichment step are loaded and a model is trained.   -
##-------------------------------------------------------------------------------------------------------------------------

source("common.R")

##--------------------------------------------------------------------------------------------------------------------------------------------------------
##  Read in the training data partition(s), build model, write performance/model statistics to /cache directory and trained model to /model directory.   -
##--------------------------------------------------------------------------------------------------------------------------------------------------------

#training_df <- read_feather(get_versioned_file_name("cache", "enriched", ".feather")) %>%
#  filter(training_ind) %>%
#  dplyr::select(-training_ind)

#saveRDS(readmission_mod_step, get_versioned_file_name("models", "readmissions", ".mod"))
