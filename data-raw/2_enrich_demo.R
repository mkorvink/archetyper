##----------------------------------------------------------------------------------------------------------------------------
##   Step 2: Data Enrichment. In this step, the base integrated data-set will be further transformed for modeling purposes.   -
##         Transformations will vary by project and might include, feature engineering, imputation, outlier removal,         -
##                                 feature selection, and the assignment of partition labels.                                -
##----------------------------------------------------------------------------------------------------------------------------

source("R/common.R")

library(caret) #partitioning
library(mice) #imputation
library(car) #cook's distance
library(corrplot) #correlation matrix

convert_not_applicable_to_na <- function(text) {
  ifelse(text == 'Not Available', NA, text) %>% return()
}

##----------------------------------------------------
##  Simple feature engineering and data preparation  -
##----------------------------------------------------
info(logger, "Preparing features...")

base_data_df <- read_feather(get_versioned_file_name("cache", "integrated", ".feather")) %>%
  mutate_at(vars(matches("PSI"), score, denominator), convert_not_applicable_to_na) %>%
  mutate_at(vars(matches("PSI"), score, denominator), as.numeric) %>%
  mutate(hospital_ownership = to_any_case(hospital_ownership),
         hospital_type = to_any_case(hospital_type),
         ehr_interop = as.factor(ifelse(is.na(ehr_interop), "U", ehr_interop)),
         score = ifelse(score == "Not Available", NA, score),
         denominator_ln = log(denominator)
  ) %>%
  mutate_if(is.character, as.factor) %>%
  rename(response = score) %>%
  filter(!is.na(response))


##------------------------------------------------------------------------
##  Imputing independent variables with predictive mean matching (PMM)   -
##------------------------------------------------------------------------
info(logger, "Imputing IVs...")

enriched_imp <- mice(base_data_df %>% dplyr::select(-response), exclude = "response", m = 5)
enriched_imp_df <- complete(enriched_imp) %>%
  tibble() %>%
  bind_cols(response = base_data_df$response)

##-----------------------------------------------
##    Removing outliers using Cook's Distance   -
##-----------------------------------------------

info(logger, "Removing outliers...")

feature_candidate_vect <- enriched_imp_df %>% dplyr::select(-response) %>% colnames()
formula <- as.formula(str_c("response ~ ", str_c(feature_candidate_vect, collapse = " + ")))
mod <- lm(formula, data = enriched_imp_df)

cooksd <- cooks.distance(mod)
base_data_df %>%
  bind_cols(cooks_sd = cooksd) %>%
  arrange(desc(cooksd))

cooks_threshold <- .01

enriched_no_outlier_df <- enriched_imp_df %>%
  bind_cols(cooks_sd = cooksd) %>%
  filter(cooks_sd < cooks_threshold) %>%
  dplyr::select(-cooks_sd)

##----------------------------------------------------------
##        Scale and center the independent variables       -
##----------------------------------------------------------
info(logger, "Scaling and centering data...")
preprocess_values <- preProcess(enriched_no_outlier_df %>% select(-response), method = c("center", "scale"))
enriched_scaled_df <- predict(preprocess_values, enriched_no_outlier_df)

##--------------------------------------------------------------------------------
##  Apply feature selection by removing by removing highly correlated features   -
##--------------------------------------------------------------------------------
info(logger, "Identifying correlated features...")
cor_mat <- cor(enriched_scaled_df %>%
                 dplyr::select_if(is.numeric))

cor_thresh <- .5
for (i in seq_len(nrow(cor_mat))) {
  for (j in seq_len(ncol(cor_mat))) {
    if (abs(cor_mat[i, j]) > cor_thresh & rownames(cor_mat)[i] != colnames(cor_mat)[j]) {
      print(str_c(rownames(cor_mat)[i], " is correlated with ", colnames(cor_mat)[j], " correlation = ", cor_mat[i, j]))
    }
  }
}

enriched_scaled_df <- enriched_scaled_df %>% dplyr::select(-PSI_90)

##-----------------------------------------------------------------------------------
##  Assign testing and training labels to the data-set using stratified sampling.   -
##-----------------------------------------------------------------------------------
info(logger, "Assigning training and testing partitions...")
train_index <- createDataPartition(enriched_scaled_df$hospital_ownership, p = .8, list = FALSE)
final_enriched_df <- enriched_scaled_df %>%
  rownames_to_column() %>%
  mutate(training_ind = rowname %in% train_index)

##------------------------------------------------------------------------------------------------
##  Write enriched dataframe to the /cache directory with version-controlled naming convention   -
##------------------------------------------------------------------------------------------------
info(logger, "Writing enriched data to /enrich directory")

enriched_data_file_name <- get_versioned_file_name("cache", "enriched", ".feather")
final_enriched_df %>% write_feather(enriched_data_file_name)
