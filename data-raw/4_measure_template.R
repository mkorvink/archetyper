source("0_common.R")
library(pROC)

testing_df <- read_feather(get_versioned_file_name("data_working", "analytic", ".feather")) %>%
  filter(!training_ind) %>%
  select(-training_ind, -rowname)
mod <- readRDS(get_versioned_file_name("models", "logistic_mod", ".mod"))

testing_df <- testing_df %>% cbind(prediction = predict(mod, testing_df, type = "response"))
testing_df %>% ggplot(aes(x = response, y = prediction)) +
  geom_boxplot()
testing_df %>% write_feather(get_versioned_file_name("data_working", "testing_w_predictions", ".feather"))

roc_obj <- roc(testing_df$response, testing_df$prediction)

# ROC Curve
plot(roc_obj)

# Print Performance Metrics
print(coords(roc_obj, "best", "threshold"))
