source("0_common.R")

library(skimr)

# Before transformations
base_data_df <- read_feather(get_versioned_file_name("data_working", "base", ".feather"))
base_data_df %>% skimr::skim()

# After transformations
analytic_data_df <- read_feather(get_versioned_file_name("data_working", "analytic", ".feather"))
analytic_data_df %>% skimr::skim()
