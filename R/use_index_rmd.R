#' Use index.Rmd (used for pkgdown::build_home())
#' @param user user name or organisation under which repository defined in\cr
#' parameter "repo" is hosted (default: "KWB-R")\cr
#' @param domain under which repository is hosted (default: "github")
#' @param stage badge declares the developmental stage of a package, according
#' to [https://www.tidyverse.org/lifecycle/](https://www.tidyverse.org/lifecycle/),
#' valid arguments are: "experimental", "maturing", "stable", "retired",
#' "archived", "dormant", "questioning"), (default: "experiment")
#' @return generates travis badge link
#' @export
#' @importFrom desc desc

use_index_rmd <- function(
  user = "KWB-R",
  domain = "github",
  stage = "experimental") {

  pkg <- read_description()


  index_rmd <- c(use_badge_appveyor(pkg$name, user,domain),
                 use_badge_travis(pkg$name, user),
                 use_badge_codecov(pkg$name, user, domain ),
                 use_badge_lifecycle(stage),
                 use_badge_cran(pkg$name),
                 "",
                 pkg$desc,
                 "",
                 use_installation(pkg$name, user, domain,output = "rmd"))


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
