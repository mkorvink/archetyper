# Step 4: Measure. In this step, the trained model will be applied to the testing partitions. 
# Performance measures can be persisted and retrieved in the presentation step.

source("common.R")
library(caret)

testing_df <- read_feather(get_versioned_file_name("cache", "enriched", ".feather")) %>%
  filter(!training_ind) %>%
  dplyr::select(-training_ind, -rowname)

mod <- readRDS(get_versioned_file_name("models", "readmissions", ".mod"))

testing_df <- testing_df %>% cbind(prediction = predict(mod, testing_df, type = "response")) %>% tibble()

testing_df %>% 
  ggplot(aes(x = response, y = prediction)) +  
  geom_point() + geom_abline(slope = 1, intercept = 0)

testing_df %>% write_feather(get_versioned_file_name("data_output", "testing_w_predictions", ".csv"))

#write to file
 RMSE(testing_df$prediction,testing_df$response)
 