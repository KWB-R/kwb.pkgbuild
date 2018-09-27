#' Use index.Rmd (used for pkgdown::build_home())
#' @param pkg package description in list format (default: \cr
#' pkg = list(name = "kwb.umberto",\cr
#' title = "R package supporting UMERTO LCA at KWB",\cr
#' desc = "Helper functions for data aggregation and visualisation of\cr
#' UMBERTO (https://www.ifu.com/umberto) model output"))\cr
#' @param user user name or organisation under which repository defined in\cr
#' parameter "repo" is hosted (default: "KWB-R")
#' @param domain under which repository is hosted (default: "github")
#' @param stage badge declares the developmental stage of a package, according
#' to [https://www.tidyverse.org/lifecycle/](https://www.tidyverse.org/lifecycle/),
#' valid arguments are: "experimental", "maturing", "stable", "retired",
#' "archived", "dormant", "questioning"), (default: "experiment")
#' @return generates travis badge link
#' @export
use_index_rmd <- function(
  pkg = list(name = "kwb.umberto",
desc = paste("Helper functions for data aggregation and",
"visualisation of UMBERTO (https://www.ifu.com/umberto)
model output")),
  user = "KWB-R",
  domain = "github",
  stage = "experimental") {

  index_rmd <- c(use_badge_appveyor(pkg$name, user,domain),
                 use_badge_travis(pkg$name, user),
                 use_badge_codecov(pkg$name, user, domain ),
                 use_badge_lifecycle(stage),
                 use_badge_cran(pkg$name),
                 "",
                 pkg$desc,
                 "",
                 use_installation(pkg$name, user, domain))


  writeLines(index_rmd, "index.Rmd")

  ignored_files <- readLines(".Rbuildignore")

  index_rmd_pat <- "^index\\.Rmd$"

  has_index_rmd <- any(grepl(x = ignored_files, pattern = index_rmd_pat,
                             fixed = TRUE))

  if (! has_index_rmd) {
    ignored_files <- append(x = ignored_files, values = "^index\\.Rmd$")
    writeLines(text = ignored_files,
               con = ".Rbuildignore")
  }

  return(index_rmd)
}
