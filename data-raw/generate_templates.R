# generate templates from files in raw data
library(readr)
library(shinymanager)
library(tidyverse)
setwd("~/git/archetyper/data-raw/")

#Demo files
common_demo <- read_file("common_demo.R")
test_demo <- read_file("0_test_demo.R")
integrate_demo <- read_file("1_integrate_demo.R")
enrich_demo <- read_file("2_enrich_demo.R")
model_demo <- read_file("3_model_demo.R")
evaluate_demo <- read_file("4_evaluate_demo.R")
present_demo <- read_file("5_present_demo.Rmd")
mediator_demo <- read_file("mediator_demo.R")
utilities_demo <- read_file("utilities_demo.R")
explore_demo <- read_file("explore_demo.R")
lint_demo <- read_file("lint_demo.R")
proj_demo <- read_file("proj_demo.txt")
api_demo <- read_file("api_demo.R")
gitignore_demo <- read_file("gitignore_demo.txt")
config_demo <- read_file("config_demo.yml")
readme_demo <- read_file("readme_demo.md")


#Template files
common_template <- read_file("common_template.R")
test_template <- read_file("0_test_template.R")
integrate_template <- read_file("1_integrate_template.R")
enrich_template <- read_file("2_enrich_template.R")
model_template <- read_file("3_model_template.R")
evaluate_template <- read_file("4_evaluate_template.R")
present_template <- read_file("5_present_template.Rmd")
mediator_template <- read_file("mediator_template.R")
utilities_template <- read_file("utilities_template.R")
explore_template <- read_file("explore_template.R")
lint_template <- read_file("lint_template.R")
proj_template <- read_file("proj_template.txt")

api_template <- read_file("api_template.R")
gitignore_template <- read_file("gitignore_template.txt")
config_template <- read_file("config_template.yml")
readme_template <- read_file("readme_template.md")

usethis::use_data(
  common_demo,
  test_demo,
  integrate_demo,
  enrich_demo,
  model_demo,
  evaluate_demo,
  present_demo,
  mediator_demo,
  utilities_demo,
  explore_demo,
  lint_demo,
  api_demo,
  gitignore_demo,
  readme_demo,
  config_demo,
  proj_demo,
  common_template,
  test_template,
  integrate_template,
  enrich_template,
  model_template,
  evaluate_template,
  present_template,
  mediator_template,
  utilities_template,
  explore_template,
  lint_template,
  api_template,
  gitignore_template,
  config_template,
  readme_template,
  proj_template,
  overwrite = T,
  internal = T
)

#lintr::lint("common_template.R")
#lintr::lint("0_test_template.R")
#lintr::lint("1_integrate_template.R")
#lintr::lint("2_enrich_template.R")
#lintr::lint("3_model_template.R")
#lintr::lint("4_evaluate_template.R")
#lintr::lint("5_present_template.Rmd")
#lintr::lint("mediator_template.R")
#lintr::lint("api_template.R")

#lintr::lint("common_demo.R")
#lintr::lint("0_test_demo.R")
#lintr::lint("1_integrate_demo.R")
#lintr::lint("2_enrich_demo.R")
#lintr::lint("3_model_demo.R")
#lintr::lint("4_evaluate_demo.R")
#lintr::lint("5_present_demo.Rmd")
#lintr::lint("mediator_demo.R")
#lintr::lint("api_demo.R")

