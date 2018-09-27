#' Use README
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

use_readme_md <- function(
  user = "KWB-R",
  domain = "github",
  stage = "experimental") {


  pkg <- read_description()

  docu_release <- sprintf("https://%s.%s.io/%s",
                          tolower(user),
                          tolower(domain),
                          tolower(pkg$name))

  docu_dev <- sprintf("%s/dev", docu_release)

  readme_md <- c(use_badge_appveyor(pkg$name, user,domain),
                 use_badge_travis(pkg$name, user),
                 use_badge_codecov(pkg$name, user, domain ),
                 use_badge_lifecycle(stage),
                 use_badge_cran(pkg$name),
                 "",
                 sprintf("# %s", pkg$name),
                 "",
                 pkg$desc,
                 "",
                 use_installation(pkg$name, user, domain),
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

