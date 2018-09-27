#' Wrapper function for preparing R package with KWB styling
#' @param author author information in list format (default:
#' list(name = "Michael Rustler", orcid = "0000-0003-0647-7726",
#' url = "http://mrustl.de"))
#' @param pkg package description in list format (default:\cr
#' pkg = list(name = "kwb.umberto",\cr
#' title = "R package supporting UMERTO LCA at KWB",\cr
#' desc = "Helper functions for data aggregation and visualisation of\cr
#' UMBERTO (https://www.ifu.com/umberto) model output"))
#' @param version user defined version number (e.g. 0.1.0) or default
#' "0.1.0.9000" version number for initial development version (default:
#' "0.1.0.9000")
#' @param license license (default: "MIT + file LICENSE")
#' @param copyright_holder list with name of copyright holder and additional
#' start_year (e.g. "2017") of copyright protection. If not specified
#' (start_year = NULL), the current year is used as year only!
#' (default: "list(name ="Kompetenzzentrum Wasser Berlin gGmbH (KWB)",
#' start_year = NULL)")
#' @param funder funder/funding agengy of R package (default: NULL), e.g. project
#' name (e.g. AQUANES)
#' @param user user name or organisation under which repository defined in
#' parameter "repo" is hosted (default: "KWB-R")
#' @param domain under which repository is hosted (default: "github")
#' @param stage badge declares the developmental stage of a package, according
#' to [https://www.tidyverse.org/lifecycle/](https://www.tidyverse.org/lifecycle/),
#' valid arguments are: "experimental", "maturing", "stable", "retired",
#' "archived", "dormant", "questioning"), (default: "experiment")
#' @return writes DESCRIPTION file using usethis::use_description() with KWB
#' style
#' @importFrom stringr str_detect
#' @importFrom fs dir_create
#' @export
use_pkg <- function(author = list(name = "Michael Rustler",
                                          orcid = "0000-0003-0647-7726",
                                          url = "http://mrustl.de"),
pkg = list(name = "kwb.umberto",
title = "R package supporting UMERTO LCA at KWB",
desc = paste0("Helper functions for data aggregation and visualisation",
" of UMBERTO (https://www.ifu.com/umberto/) model output.")),
version = "0.1.0.9000",
license = "MIT + file LICENSE",
copyright_holder = list(name ="Kompetenzzentrum Wasser Berlin gGmbH (KWB)",
                        start_year = NULL),
                            funder = NULL,
user = "KWB-R",
domain = "github",
stage = "experimental") {


### 1) Create DESCRIPTION file
use_description(author,
                pkg,
                version,
                license,
                copyright_holder_name = copyright_holder$name)



### 2) Create MIT LICENSE file
mit_licence <- stringr::str_detect(string = license, pattern = "MIT")

if(mit_licence) {
use_mit_license(copyright_holder)
}


### 3) Create PKGDOWN YML
use_pkgdown(author, copyright_holder$name)

### 4) Create .gitlab-ci.yml
fs::dir_create("docs")
use_gitlab_ci()

### 5) Create .travis.yml
use_travis()

### 6) Create appveyor.yml
use_appveyor()

### 7) Use codecov
use_codecov()

### 8) Use index.Rmd (for pkgdown home:
### see: http://pkgdown.r-lib.org/articles/pkgdown.html#home-page)
use_index_rmd(pkg,user,domain, stage)

### 9) Use README.md (for github page)
use_readme_md(pkg,user,domain, stage)

### 10) Use NEWS.md
use_news_md(pkg$name, version)
}

