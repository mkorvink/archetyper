# This is a demo project to provide a representative example of the data mining and modeling workflow.  In this example
# we will predict hospital readmission rates based on a variety of hospital-level characteristics.  All data used in this project is 
# publically available.

# Source: Hospital Compare https://data.cms.gov/provider-data/ (last accessed Feb 18 2021)

# Step 1: Data Integration: The source files are joined to produce base dataset comprised of unique hospitals as rows (i.e. observations) and 
# hospital characteristics as columns (i.e. features).  


#common.R is sourced in each component script. It is reposible for loading shared libraries, constants, uutility functions, and logger.
source("common.R")

info(logger, "Loading, integrating, and transforming source data...")

hospital_info_df <- read_csv("data_input/Hospital_General_Information.csv") %>%
  rename_all(to_any_case) %>%
  dplyr::select(facility_id, state, hospital_type, hospital_ownership, emergency_services, meets_criteria_for_promoting_interoperability_of_eh_rs) %>%
  rename(ehr_interop = meets_criteria_for_promoting_interoperability_of_eh_rs)

readmission_df <- read_csv("data_input/Unplanned_Hospital_Visits-Hospital.csv") %>%
  rename_all(to_any_case) %>%
  filter(measure_id == "READM_30_HOSP_WIDE") %>%
  dplyr::select(facility_id, denominator, score)

complications_df <- read_csv("data_input/CMS_PSI_6_decimal_file.csv") %>%
  rename_all(to_any_case) %>%
  dplyr::select(facility_id, measure_id, rate) %>%
  mutate(measure_id = str_replace_all(measure_id, "-", "_")) %>%
  pivot_wider(names_from = measure_id, values_from = rate)

integrated_df <- hospital_info_df %>%
  inner_join(readmission_df, "facility_id") %>%
  inner_join(complications_df, by = "facility_id")

info(logger, "Writing integrated data to /cache directory...")

integrated_data_file_name <- get_versioned_file_name("cache", "integrated", ".feather")
integrated_df %>% write_feather(integrated_data_file_name)