#' Use README.Rmd
#' @param pkg package description in list format (default:\cr
#' pkg = list(name = "kwb.lca",\cr
#' title = "R package supporting UMERTO LCA at KWB",\cr
#' desc = "Helper functions for data aggregation and visualisation of\cr
#' UMBERTO (https://www.ifu.com/umberto) model output"))
#' @param user user name or organisation under which repository defined in
#' parameter "repo" is hosted (default: "KWB-R")
#' @param domain under which repository is hosted (default: "github")
#' @param stage badge declares the developmental stage of a package, according
#' to [https://www.tidyverse.org/lifecycle/](https://www.tidyverse.org/lifecycle/),
#' valid arguments are: "experimental", "maturing", "stable", "retired",
#' "archived", "dormant", "questioning"), (default: "experiment")
#' @return generates travis badge link
#' @export
use_readme_rmd <- function(
  pkg = list(name = "kwb.lca",
desc = paste("Helper functions for data aggregation and",
"visualisation of UMBERTO (https://www.ifu.com/umberto)
model output")),
  user = "KWB-R",
  domain = "github",
  stage = "experimental") {

readme_rmd <- c(use_badge_appveyor(pkg$name, user,domain),
  use_badge_travis(pkg$name, user),
  use_badge_codecov(pkg$name, user, domain ),
  use_badge_lifecycle(stage),
  use_badge_cran(pkg$name),
  "",
  sprintf("# %s", pkg$name),
  "",
  pkg$desc)


writeLines(readme_rmd, "README.Rmd")

ignored_files <- readLines(".Rbuildignore")

readme_rmd_pat <- "^README\\.Rmd$"

has_readme_rmd <- any(grepl(x = ignored_files, pattern = readme_rmd_pat,
                            fixed = TRUE))

if (! has_readme_rmd) {
  ignored_files <- append(x = ignored_files, values = "^README\\.Rmd$")
  writeLines(text = ignored_files,
             con = ".Rbuildignore")
}

return(readme_rmd)
}

#' Use README
#' @param pkg package description in list format (default:\cr
#' pkg = list(name = "kwb.lca",\cr
#' title = "R package supporting UMERTO LCA at KWB",\cr
#' desc = "Helper functions for data aggregation and visualisation of\cr
#' UMBERTO (https://www.ifu.com/umberto) model output"))
#' @param user user name or organisation under which repository defined in
#' parameter "repo" is hosted (default: "KWB-R")
#' @param domain under which repository is hosted (default: "github")
#' @param stage badge declares the developmental stage of a package, according
#' to [https://www.tidyverse.org/lifecycle/](https://www.tidyverse.org/lifecycle/),
#' valid arguments are: "experimental", "maturing", "stable", "retired",
#' "archived", "dormant", "questioning"), (default: "experiment")
#' @return generates travis badge link
#' @export
use_readme <- function(
  pkg = list(name = "kwb.lca",
desc = paste("Helper functions for data aggregation and",
"visualisation of UMBERTO (https://www.ifu.com/umberto)
model output")),
  user = "KWB-R",
  domain = "github",
  stage = "experimental") {

  readme_rmd <- use_readme_rmd(pkg, user, domain, stage)

  docu_release <- sprintf("https://%s.%s.io/%s",
                          tolower(user),
                          tolower(domain),
                          tolower(pkg$name))

  docu_dev <- sprintf("%s/dev", docu_release)

  readme_md <- c(readme_rmd,
                 "",
                "## Documentation",
                "",
                sprintf("Release: [%s](%s)", docu_release,docu_release),
                "",
                sprintf("Development: [%s](%s)", docu_dev,docu_dev))

  writeLines(readme_md, "README.md")

  ignored_files <- readLines(".Rbuildignore")

  readme_md_pat <- "^README\\.md$"

  has_readme_md <- any(grepl(x = ignored_files, pattern = readme_md_pat,
                              fixed = TRUE))

  if (! has_readme_md) {
    ignored_files <- append(x = ignored_files, values = "^README\\.md$")
    writeLines(text = ignored_files,
               con = ".Rbuildignore")
  }

}

