source("0_common.R")

# libraries specific to the script
library(caret)
library(mice)
library(car)
library(Boruta)
library(corrplot)

base_data_df <- read_feather(get_versioned_file_name("data_working", "base", ".feather")) %>% filter(!is.na(survived))

# feature engineering----------------------------------------------------------------------------------------
analytic_df <- base_data_df %>%
  rename(response = survived) %>%
  mutate(honorific = case_when(
    str_detect(name, "Dr\\.") ~ "DR",
    str_detect(name, "Mrs\\.|Countess|Dona\\.") ~ "MRS",
    str_detect(name, "Miss\\.|Ms\\.|Mme\\.|Mlle\\.") ~ "MISS",
    str_detect(name, "Mr\\.|Don\\.|Sir\\.") ~ "MR",
    str_detect(name, "Master\\.") ~ "MASTER",
    str_detect(name, "Rev\\.") ~ "REV",
    str_detect(name, "Don\\.|Dona\\.") ~ "DON_DONA",
    str_detect(name, "Col\\.|Major\\.|Capt\\.") ~ "OFFICER",
    T ~ "OTHER"
  )) %>%
  select(-passenger_id, -name, -ticket, -cabin) %>%
  mutate_if(is.character, as.factor) %>%
  mutate(response = as.factor(response))


# impute data----------------------------------------------------------------------------------------
analytic_imp <- mice(analytic_df %>% select(-response), exclude = "response", m = 5)
analytic_imp_df <- complete(analytic_imp) %>%
  tibble() %>%
  bind_cols(response = analytic_df$response)


# Review outliers----------------------------------------------------------------------------------------
mod <- glm("response ~ pclass + sex + age + sib_sp + fare + embarked", data = analytic_imp_df, family = "binomial")
cooksd <- cooks.distance(mod)
base_data_df %>%
  bind_cols(cooks_sd = cooksd) %>%
  arrange(desc(cooksd))
cooks_threshold <- .02 # set this manually

analytic_no_outlier_df <- analytic_imp_df %>%
  bind_cols(cooks_sd = cooksd) %>%
  filter(cooks_sd < cooks_threshold) %>%
  select(-cooks_sd)

# plot(cooksd, pch="*", cex=2, main="Influential Obs by Cooks distance")  # plot cook's distance
# abline(h = 4*mean(cooksd, na.rm=T), col="red")  # add cutoff line
# text(x=1:length(cooksd)+1, y=cooksd, labels=ifelse(cooksd>4*mean(cooksd, na.rm=T),names(cooksd),""), col="red")  # add labels

# scale data----------------------------------------------------------------------------------------
preprocess_values <- preProcess(analytic_no_outlier_df, method = c("center", "scale"))
analytic_scaled_df <- predict(preprocess_values, analytic_no_outlier_df)


# correlated features----------------------------------------------------------------------------------------
cor_mat <- cor(analytic_scaled_df %>% select_if(is.numeric))

cor_thresh <- .5
for (i in seq_len(nrow(cor_mat))) {
  for (j in seq_len(ncol(cor_mat))) {
    if (abs(cor_mat[i, j]) > cor_thresh & rownames(cor_mat)[i] != colnames(cor_mat)[j]) {
      print(str_c(rownames(cor_mat)[i], " is correlated with ", colnames(cor_mat)[j], " correlation = ", cor_mat[i, j]))
    }
  }
}

# feature selection (wrapper method)----------------------------------------------------------------------------------------
set.seed(111)
boruta_model_train <- Boruta(response ~ ., data = analytic_scaled_df, doTrace = 2)
confirmed_feature_vect <- tibble(
  feature_name = names(boruta_model_train$finalDecision),
  feature_status = boruta_model_train$finalDecision
) %>%
  filter(feature_status == "Confirmed") %>%
  pull(feature_name)

analytic_final_feature_df <- analytic_scaled_df %>% select(confirmed_feature_vect, response)

# data partitioning----------------------------------------------------------------------------------------
train_index <- createDataPartition(analytic_final_feature_df$response, p = .8, list = FALSE)

# writing analytic file with training----------------------------------------------------------------------------------------
analytic_final_feature_df %>%
  rownames_to_column() %>%
  mutate(training_ind = rowname %in% train_index) %>%
  write_feather(get_versioned_file_name("data_working", "analytic", ".feather"))
