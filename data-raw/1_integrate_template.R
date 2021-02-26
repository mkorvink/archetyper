##-------------------------------------------------------------------------------------------------------------------------------------------------
##  Step 1: Data Integration: The source files are joined to produce base data-set comprised of unique hospitals as rows (i.e. observations) and  -
##                                             # hospital characteristics as columns (i.e. features).                                             -
##-------------------------------------------------------------------------------------------------------------------------------------------------

source("R/common.R")

info(logger, "Loading, integrating, and transforming source data...")

##----------------------------------------------------------------------------------------------------
##  Gather and integrate data from the /data_input directory or external data store (e.g. database)  -
##----------------------------------------------------------------------------------------------------

info(logger, "Writing integrated data to /cache directory...")

##-------------------------------------------------------------------------------------------
##  Write integrated data to the /data_working directory. File name should be version controlled.  -
##-------------------------------------------------------------------------------------------

#integrated_data_file_name <- get_versioned_file_name("data_working", "integrated", ".feather")
#integrated_df %>% write_feather(integrated_data_file_name)
