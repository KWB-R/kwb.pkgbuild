# use_pkg ----------------------------------------------------------------------

#' Wrapper function for preparing R package with KWB styling
#'
#' @param author author information in list format (default:
#'   kwb.pkgbuild:::kwb_author("rustler"))
#' @param pkg package description in list format (default:
#'   kwb.pkgbuild:::kwb_package("kwb.umberto"))
#' @param version user defined version number (e.g. 0.1.0) or default
#'   "0.0.0.9000" version number for initial development version (default:
#'   "0.0.0.9000")
#' @param license license (default: "MIT + file LICENSE")
#' @param copyright_holder list with name of copyright holder and additional
#'   start_year (e.g. "2017") of copyright protection. If not specified
#'   (start_year = NULL), the current year is used as year only! (default:
#'   "list(name = kwb.pkgbuild:::kwb_string(), start_year = NULL)")
#' @param funder funder/funding agency of R package (default: NULL), e.g.
#'   project name (e.g. AQUANES)
#' @param user user name or organisation under which repository defined in
#'   parameter "repo" is hosted (default: "KWB-R")
#' @param domain under which repository is hosted (default: "github")
#' @param stage badge declares the developmental stage of a package, according
#'   to
#'   [https://www.tidyverse.org/lifecycle/](https://www.tidyverse.org/lifecycle/),
#'    valid arguments are: "experimental", "maturing", "stable", "retired",
#'   "archived", "dormant", "questioning"), (default: "experiment")
#' @return writes DESCRIPTION file using usethis::use_description() with KWB
#'   style
#' @importFrom stringr str_detect
#' @importFrom fs dir_create
#' @param auto_build_pkgdown  prepare Travis for pkgdown::build_site() (default:
#'   FALSE), only possible if GITHUB repo already existing
#' @param dbg print debug messages (default: TRUE)
#' @param ... additional arguments passed to use_autopkgdown() (only releveant
#'   if "auto_build_pkgdown" == TRUE)
#' @export
use_pkg <- function(
  author = kwb_author("rustler"),
  pkg = kwb_package("kwb.umberto"),
  version = "0.0.0.9000",
  license = "MIT + file LICENSE",
  copyright_holder = list(name = kwb_string(), start_year = NULL),
  funder = NULL,
  user = "KWB-R",
  domain = "github",
  stage = "experimental",
  auto_build_pkgdown = FALSE,
  dbg = TRUE,
  ...
)
{
  # Create DESCRIPTION file
  use_description(
    author, pkg, version, license,
    copyright_holder_name = copyright_holder$name, funder = funder
  )

  # Create MIT LICENSE file
  mit_licence <- stringr::str_detect(string = license, pattern = "MIT")

  if (mit_licence) {
    use_mit_license(copyright_holder)
  }

  # Create PKGDOWN YML
  use_pkgdown(author, copyright_holder$name)

  if (auto_build_pkgdown) {
    use_autopkgdown(repo = pkg, org = user, dbg = dbg, ...)
  } else {
    # Create .travis.yml
    use_travis()
    # Create .gitlab-ci.yml for "master" branch with "docs" folder
    fs::dir_create("docs")
    use_gitlab_ci_docs()
  }

  # Create appveyor.yml
  use_appveyor()

  # Use codecov
  use_codecov()

  # Use index.Rmd (for pkgdown home:
  # see: https://pkgdown.r-lib.org/articles/pkgdown.html#home-page)
  use_index_rmd(user, domain, stage)

  # Use README.md (for github page)
  use_readme_md(user, domain, stage)

  # Use NEWS.md
  use_news_md()
}
