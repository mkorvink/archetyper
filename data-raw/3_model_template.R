source("0_common.R")

library(broom)
library(feather)

training_df <- read_feather(get_versioned_file_name("data_working", "analytic", ".feather")) %>%
  filter(training_ind) %>%
  select(-training_ind, -rowname)

feature_vect <- training_df %>%
  select(-response) %>%
  colnames()
formula <- as.formula(str_c("response ~ ", str_c(feature_vect, collapse = " + ")))
logistic_mod <- glm(formula, data = training_df, family = "binomial")

summary(logistic_mod)

broom::glance(logistic_mod) %>% write_feather(get_versioned_file_name("data_working", "perf", ".feather"))
broom::tidy(logistic_mod, conf.int = T) %>% write_feather(get_versioned_file_name("data_working", "feature_dtl", ".feather"))

saveRDS(logistic_mod, get_versioned_file_name("models", "logistic_mod", ".mod"))
