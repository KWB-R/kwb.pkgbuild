#' Badge appveyor
#' @param repo name of repository
#' @param user user name or organisation under which repository defined in
#' parameter "repo" is hosted (default: KWB-R")
#' @param domain under which repository is hosted (default: "github")
#'
#' @return generates appveyor badge link
#' @export
use_badge_appveyor <- function(repo, user = "KWB-R", domain = "github") {

  if(is.null(repo)) {

    pkg <- read_description()
    pkgname <- pkg$name

  }

  read_description(file = "DESCRIPTION")

  sprintf(paste0("[![Appveyor build Status](https://ci.appveyor.com/",
                 "api/projects/status/%s/",
                 "%s/%s?branch=master&svg=true)]",
                 "(https://ci.appveyor.com/project/%s/%s/branch/master)"),
          domain,
          user,
          repo,
          user,
          gsub(pattern = "\\.", replacement = "-", repo)
          )
}

#' Badge travis
#' @param repo name of repository
#' @param user user name or organisation under which repository defined in
#' parameter "repo" is hosted (default: KWB-R")
#' @return generates travis badge link
#' @export
use_badge_travis <- function(repo, user = "KWB-R") {

  if(is.null(repo)) {

    pkg <- read_description()
    pkgname <- pkg$name

  }


  sprintf(paste0("[![Travis build Status](https://travis-ci.org/",
                 "%s/%s.svg?branch=master)](https://travis-ci.org/%s/%s)"),
          user,
          repo,
          user,
          repo)
}

#' Badge codecov
#' @param repo name of repository
#' @param user user name or organisation under which repository defined in
#' parameter "repo" is hosted (default: KWB-R")
#' @param domain under which repository is hosted (default: "github")
#' @return generates codecov badge link
#' @export
use_badge_codecov <- function(repo, user = "KWB-R", domain = "github") {

  if(is.null(repo)) {

    pkg <- read_description()
    pkgname <- pkg$name

  }

  sprintf(paste0("[![codecov](https://codecov.io/%s/%s/%s/branch/",
                 "master/graphs/badge.svg)](https://codecov.io/%s/%s/%s)"),
                 domain,
                 user,
                 repo,
                 domain,
                 user,
                 repo)

}

#' Badge lifecycle
#' @param stage badge declares the developmental stage of a package, according
#' to [https://www.tidyverse.org/lifecycle/](https://www.tidyverse.org/lifecycle/),
#' valid arguments are: "experimental", "maturing", "stable", "retired",
#' "archived", "dormant", "questioning"), (default: "experiment")
#' @return generates lifecycle badge link
#' @export
use_badge_lifecycle <- function(stage = "experimental") {

  stages <- usethis:::stages
  stage <- match.arg(tolower(stage), names(stages))
  colour <- stages[[stage]]
  src <- paste0("https://img.shields.io/badge/lifecycle-",
                stage, "-", colour, ".svg")
  href <- paste0("https://www.tidyverse.org/lifecycle/#", stage)
  sprintf("[![lifecycle](%s)](%s)", src, href)
}

#' Badge CRAN
#' @param pkgname name of R package
#' @importFrom httr GET status_code
#' @return generates CRAN badge link
#' @export
use_badge_cran <- function(pkgname) {

  if(is.null(pkgname)) {

    pkg <- read_description()
    pkgname <- pkg$name

  }

  cran_link <- sprintf("https://cran.r-project.org/package=%s", pkgname)

  pkg_on_cran <- httr::status_code(x = httr::GET(cran_link)) == 200

  href <- "()"
  if (pkg_on_cran) href <- sprintf("(%s)",cran_link)


  sprintf(paste0("[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/",
  "%s)]%s"),
  pkgname,
  href)
}

