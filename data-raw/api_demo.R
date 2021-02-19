#
# This is a Plumber API. You can run the API by clicking
# the 'Run API' button above.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#
library(plumber)

mod <- readRDS("models/hospital_readmissions_readmissions_2021-02-19.mod") 

#* @readmission_risk  Demo API

#* Get readmission prediction
#* @param dt:list
#* @post /predict
function(dt = hosp_record) {
  predict(mod, dt, type = "response") %>% return()
}

#Request body for sample call
#{
#  "dt": {"state": "AL",
#    "hospital_type": "acute_care_hospitals",
#    "hospital_ownership": "government_hospital_district_or_authority",
#    "emergency_services": "Yes",
#    "ehr_interop": "Y",
#    "denominator": 1.4791,
#    "PSI_10": -1.3895,
#    "PSI_11": 0.597,
#    "PSI_12": -0.9487,
#    "PSI_13": -0.102,
#    "PSI_14": -1.1131,
#    "PSI_15": -0.9439,
#    "PSI_3": 0.029,
#    "PSI_6": -0.5752,
#    "PSI_8": -1.4081,
#    "PSI_9": -0.3028,
#    "denominator_ln": 1.3489}
#}