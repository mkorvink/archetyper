# Step 3: Modeling. In this step, the training partitions from the enrichment step are loaded and a model is trained.

source("common.R")

library(broom)
library(feather)
library(performance)

library(MASS)

training_df <- read_feather(get_versioned_file_name("cache", "enriched", ".feather")) %>%
  filter(training_ind) %>%
  dplyr::select(-training_ind, -rowname)

feature_vect <- training_df %>%
  dplyr::select(-response) %>%
  colnames()

formula <- as.formula(str_c("response ~ ", str_c(feature_vect, collapse = " + ")))
readmission_mod <- lm(formula, data = training_df)

#TODO: include performance visualizations.

readmission_mod_step <- stepAIC(readmission_mod)
summary(readmission_mod_step)
#check_model(readmission_mod_step)

broom::glance(readmission_mod_step) %>% write_feather(get_versioned_file_name("cache", "perf", ".feather")) 
broom::tidy(readmission_mod_step, conf.int = T) %>% write_feather(get_versioned_file_name("cache", "feature_dtl", ".feather"))

saveRDS(readmission_mod_step, get_versioned_file_name("models", "readmissions", ".mod"))
