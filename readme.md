<a href='https://github.com/mkorvink/archetyper/'><img src='man/figures/archetyper_hex.png' align="right" height="139" /></a>

## Overview

archetyper is a tool to initialize data mining projects by generating common workflow components and surrounding files to support technical best practices:

  - `generate()` creates a new project with templated files and directories to support a data mining workflow.

You can learn more about archetyper in `vignette("archetyper")`.


### Development version

To get a bug fix or to use a feature from the development version, you
can install the development version of archetyper from GitHub.

``` r
# install.packages("devtools")
devtools::install_github("mkorvink/archetyper")
```

## Usage

``` r
 library(archetyper)

 archetyper::generate("majestic_12")

#> list.files("majestic_12/")
 [1] "0_test.R"      "1_integrate.R" "2_enrich.R"    "3_model.R"     "4_measure.R"   "5_present.Rmd"
 [7] "api.R"         "cache"         "common.R"      "data_input"    "data_output"   "docs"         
[13] "lint.R"        "mediator.R"    "models"        "readme.md"     "utilities.R"  

```

Acknowledgments
---------------

This readme was modeled after the dplyr readme.  
