# Common Libraries
library(tidyverse)
library(snakecase)
library(feather)
library(config) #remove if yml file is not used
library(log4r)
library(bannerCommenter)
library(here)
source(str_c(here(),"/R/utilities.R"))

# Constants
project_name <- "hospital_readmissions"

# Global options
options(scipen = 1000)

logger <- log4r::logger()
