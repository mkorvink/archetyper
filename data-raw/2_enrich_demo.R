# Step 2: Data Enrichment. In this step, the base integrated dataset will be further transformed for modeling purposes.
# Transformations will vary by project and might include, feature engineering, imputation, outlier removal,
# feature selection, and the assignment of partition labels. 

source("common.R")

library(caret) #partitioning
library(mice) #imputation
library(car) #cook's
library(corrplot) #cor matrix

convert_not_applicable_to_na <- function(text) {
  ifelse(text == 'Not Available', NA, text) %>% return()
}

base_data_df <- read_feather(get_versioned_file_name("cache", "integrated", ".feather")) %>% 
  dplyr::select(-facility_id) %>%  #TODO: move to integrate?
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

# impute data----------------------------------------------------------------------------------------
analytic_imp <- mice(base_data_df %>% dplyr::select(-response), exclude = "response", m = 5)
analytic_imp_df <- complete(analytic_imp) %>%
  tibble() %>%
  bind_cols(response = base_data_df$response)

# review and remove outliers-------------------------------------------------------------------------
feature_candidate_vect <- analytic_imp_df %>% dplyr::select(-response) %>% colnames()

formula <- as.formula(str_c("response ~ ", str_c(feature_candidate_vect, collapse = " + ")))
mod <- lm(formula, data = analytic_imp_df)

cooksd <- cooks.distance(mod)
base_data_df %>%
  bind_cols(cooks_sd = cooksd) %>%
  arrange(desc(cooksd))
cooks_threshold <- .01 # set this manually

analytic_no_outlier_df <- analytic_imp_df %>%
  bind_cols(cooks_sd = cooksd) %>%
  filter(cooks_sd < cooks_threshold) %>%
  dplyr::select(-cooks_sd)

#TODO: remove?
 #plot(cooksd, pch="*", cex=2, main="Influential Obs by Cooks distance")  # plot cook's distance
# abline(h = 4*mean(cooksd, na.rm=T), col="red")  # add cutoff line
# text(x=1:length(cooksd)+1, y=cooksd, labels=ifelse(cooksd>4*mean(cooksd, na.rm=T),names(cooksd),""), col="red")  # add labels

# scale data----------------------------------------------------------------------------------------
preprocess_values <- preProcess(analytic_no_outlier_df %>% select(-response), method = c("center", "scale"))
analytic_scaled_df <- predict(preprocess_values, analytic_no_outlier_df)

# feature selection----------------------------------------------------------------------------------
cor_mat <- cor(analytic_scaled_df %>% 
                 dplyr::select_if(is.numeric))

cor_thresh <- .5
for (i in seq_len(nrow(cor_mat))) {
  for (j in seq_len(ncol(cor_mat))) {
    if (abs(cor_mat[i, j]) > cor_thresh & rownames(cor_mat)[i] != colnames(cor_mat)[j]) {
      print(str_c(rownames(cor_mat)[i], " is correlated with ", colnames(cor_mat)[j], " correlation = ", cor_mat[i, j]))
    }
  }
}
#TODO: Make dynamic?
analytic_scaled_df <- analytic_scaled_df %>% dplyr::select(-PSI_90)


# data partitioning----------------------------------------------------------------------------------------
train_index <- createDataPartition(analytic_scaled_df$hospital_ownership, p = .8, list = FALSE)

# writing enriched file with training----------------------------------------------------------------------------------------
enriched_data_file_name <- get_versioned_file_name("cache", "enriched", ".feather")
analytic_scaled_df %>%
  rownames_to_column() %>%
  mutate(training_ind = rowname %in% train_index) %>%
  write_feather(enriched_data_file_name)
