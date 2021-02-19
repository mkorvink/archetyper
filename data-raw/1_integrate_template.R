source("0_common.R")

library(RJDBC)
library(titanic)

##Read externalized DB properties from yml file
#db <- config::get("test_database")
#
##connect to DB using JDBC
#drv <- RJDBC::JDBC(driverClass = db$driverclass, classPath =  Sys.glob(str_c(getwd(),"/drivers/*")))
#conn <- dbConnect(drv,db$connectionstring, db$username, db$password)
#
##Read in source data
#sql <- 'select count(*) from qadv_prod.prov_cdm'
#db_result_df <- dbGetQuery(conn, sql) %>% tibble()
#base_data_df <- db_result_df
#Disconnect from DB
#dbDisconnect(conn)

#Store output in a base data data frame (2x2 observations and features)
base_data_df <- titanic_train  %>% bind_rows(titanic_test) %>%  rename_all(to_any_case)

#Persist base data
base_data_df %>% write_feather(get_versioned_file_name("data_working", "base", ".feather"))

