#' Badge appveyor
#' @param repo name of repository (default: NULL)
#' @param user user name or organisation under which repository defined in
#' parameter "repo" is hosted (default: KWB-R")
#' @param domain under which repository is hosted (default: "github")
#'
#' @return generates appveyor badge link
#' @export
use_badge_appveyor <- function(repo = NULL, user = "KWB-R", domain = "github") {
  pkgname <- get_pkgname(repo)

  sprintf(
    paste0(
      "[![Appveyor build Status](https://ci.appveyor.com/",
      "api/projects/status/%s/",
      "%s/%s?branch=master&svg=true)]",
      "(https://ci.appveyor.com/project/%s/%s/branch/master)"
    ),
    domain,
    user,
    pkgname,
    user,
    gsub(pattern = "\\.", replacement = "-", pkgname)
  )
}

#' Badge travis
#' @param repo name of repository (default: NULL)
#' @param user user name or organisation under which repository defined in
#' parameter "repo" is hosted (default: KWB-R")
#' @return generates travis badge link
#' @export
use_badge_travis <- function(repo = NULL, user = "KWB-R") {
  pkgname <- get_pkgname(repo)

  sprintf(
    paste0(
      "[![Travis build Status](https://travis-ci.org/",
      "%s/%s.svg?branch=master)](https://travis-ci.org/%s/%s)"
    ),
    user,
    pkgname,
    user,
    pkgname
  )
}

#' Badge codecov
#' @param repo name of repository (default: NULL)
#' @param user user name or organisation under which repository defined in
#' parameter "repo" is hosted (default: KWB-R")
#' @param domain under which repository is hosted (default: "github")
#' @return generates codecov badge link
#' @export
use_badge_codecov <- function(repo = NULL, user = "KWB-R", domain = "github") {
  pkgname <- get_pkgname(repo)

  sprintf(
    paste0(
      "[![codecov](https://codecov.io/%s/%s/%s/branch/",
      "master/graphs/badge.svg)](https://codecov.io/%s/%s/%s)"
    ),
    domain,
    user,
    pkgname,
    domain,
    user,
    pkgname
  )
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
  src <- paste0(
    "https://img.shields.io/badge/lifecycle-",
    stage, "-", colour, ".svg"
  )
  href <- paste0("https://www.tidyverse.org/lifecycle/#", stage)
  sprintf("[![Project Status](%s)](%s)", src, href)
}

#' Helper function for checking if docu on CRAN
#' @keywords internal
#' @noRd
is_on_cran <- function(cran_link) {
  try(httr::status_code(x = httr::GET(cran_link)) == 200,silent = TRUE)
  # tryCatch(httr::status_code(x = httr::GET(cran_link)) == 200,
  #   error = function(e) {
  #     print("caught error")
  #     cat(sprintf(
  #       "Requesting %s failed with an error:\n%s",
  #       cran_link, e
  #     ))
  #     "error"})
  }



#' Badge CRAN
#' @param pkgname name of R package (default: NULL)
#' @importFrom httr GET status_code
#' @return generates CRAN badge link
#' @importFrom assertthat is.error
#' @importFrom kwb.utils defaultIfNULL
#' @export
use_badge_cran <- function(pkgname = NULL) {

  pkgname <- kwb.utils::defaultIfNULL(pkgname, get_pkgname(pkgname))

  cran_mirrors <- sprintf("https://cran.%s.org", c("r-project", "rstudio"))
  cran_mirrors_link <- sprintf("%s/package=%s", cran_mirrors, pkgname)

  res_link1 <- is_on_cran(cran_mirrors_link[1])
  res_link2 <- is_on_cran(cran_mirrors_link[2])

  is_no_error <- c(assertthat::is.error(res_link1),
                   assertthat::is.error(res_link2))

  pkg_on_cran <- tryCatch(ifelse(! assertthat::is.error(res_link1),
                                 res_link1,
                                 res_link2),
  error = function(e) {
    print("caught error")
    cat(sprintf(
      "Requesting %s and %s failed with an error:\n%s",
      res_link1,
      res_link2,
      e
    ))
  }
  )

  href <- "()"
  if (pkg_on_cran) href <- sprintf("(%s)", cran_mirrors_link[is_no_error])


  sprintf(
    paste0(
      "[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/",
      "%s)]%s"
    ),
    pkgname,
    href
  )
}
