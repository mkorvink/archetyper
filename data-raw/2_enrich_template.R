##----------------------------------------------------------------------------------------------------------------------------
##   Step 2: Data Enrichment. In this step, the base integrated data-set will be further transformed for modeling purposes.   -
##         Transformations will vary by project and might include, feature engineering, imputation, outlier removal,         -
##                                 feature selection, and the assignment of partition labels.                                -
##----------------------------------------------------------------------------------------------------------------------------

source("R/common.R")

#integrated_df <- read_feather(get_versioned_file_name("cache", "integrated", ".feather"))

##-------------------------------------------------------------------------------------------------------
##  Feature engineering, outlier removal, imputation, feature selection, etc. (see demo for examples)   -
##-------------------------------------------------------------------------------------------------------

#enriched_df <- integrated_df

##--------------------------------------------------------------------------------------------------
##  Write enriched dataframe to the /cache directory with version-controlled naming convention   -
##--------------------------------------------------------------------------------------------------

#enriched_data_file_name <- get_versioned_file_name("cache", "enriched", ".feather")
#enriched_df %>% write_feather(enriched_data_file_name)
