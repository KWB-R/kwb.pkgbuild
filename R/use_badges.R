# grammars ---------------------------------------------------------------------

grammars <- list(
  general = list(
    url = "[![<title>](<src>)](<href>)",
    src = "<address>/<path_1><params>",
    href = "<address>/<path_2>",
    branch = "master"
  ),
  appveyor = list(
    title = "Appveyor build Status",
    address = "https://ci.appveyor.com",
    path_1 = "api/projects/status/<domain>/<user>/<pkgname>",
    path_2 = "project/<user>/<pkgname_dash>/branch/<branch>",
    params = "?branch=<branch>&svg=true"
  ),
  travis = list(
    title = "Travis build Status",
    address = "https://travis-ci.org",
    path_1 = "<user>/<pkgname>.svg?branch=<branch>",
    path_2 = "<user>/<pkgname>",
    params = ""
  ),
  codecov = list(
    title = "codecov",
    address = "https://codecov.io",
    path_1 = "<path_2>/branch/<branch>/graphs/badge.svg",
    path_2 = "<domain>/<user>/<pkgname>",
    params = ""
  ),
  lifecycle = list(
    title = "Project Status",
    src = "https://img.shields.io/badge/lifecycle-<stage>-<colour>.svg",
    href = "https://www.tidyverse.org/lifecycle/#<stage>"
  ),
  cran = list(
    title = "CRAN_Status_Badge",
    src = "https://www.r-pkg.org/badges/version/<pkgname>"
  ),
  mirror = list(
    url = "https://cran.<org>.org/package=<pkgname>"
  )
)

# use_badge_appveyor -----------------------------------------------------------

#' Badge appveyor
#' @param repo name of repository (default: NULL)
#' @param user user name or organisation under which repository defined in
#' parameter "repo" is hosted (default: KWB-R")
#' @param domain under which repository is hosted (default: "github")
#'
#' @return generates appveyor badge link
#' @export
use_badge_appveyor <- function(repo = NULL, user = "KWB-R", domain = "github")
{
  pkgname <- get_pkgname(repo)

  kwb.utils::resolve(
    "url",
    grammars$general,
    grammars$appveyor,
    domain = domain,
    user = user,
    pkgname = pkgname,
    pkgname_dash = gsub("\\.", "-", pkgname)
  )
}

# use_badge_travis -------------------------------------------------------------

#' Badge travis
#' @param repo name of repository (default: NULL)
#' @param user user name or organisation under which repository defined in
#' parameter "repo" is hosted (default: KWB-R")
#' @return generates travis badge link
#' @export
use_badge_travis <- function(repo = NULL, user = "KWB-R")
{
  kwb.utils::resolve(
    "url",
    grammars$general,
    grammars$travis,
    user = user,
    pkgname = get_pkgname(repo)
  )
}

# use_badge_codecov ------------------------------------------------------------

#' Badge codecov
#' @param repo name of repository (default: NULL)
#' @param user user name or organisation under which repository defined in
#' parameter "repo" is hosted (default: KWB-R")
#' @param domain under which repository is hosted (default: "github")
#' @return generates codecov badge link
#' @export
use_badge_codecov <- function(repo = NULL, user = "KWB-R", domain = "github")
{
  kwb.utils::resolve(
    "url",
    grammars$general,
    grammars$codecov,
    domain = domain,
    user = user,
    pkgname = get_pkgname(repo)
  )
}

# use_badge_lifecycle ----------------------------------------------------------

#' Badge lifecycle
#' @param stage badge declares the developmental stage of a package, according
#'   to
#'   [https://www.tidyverse.org/lifecycle/](https://www.tidyverse.org/lifecycle/),
#'    valid arguments are: "experimental", "maturing", "stable", "retired",
#'   "archived", "dormant", "questioning"), (default: "experiment")
#' @return generates lifecycle badge link
#' @export
use_badge_lifecycle <- function(stage = "experimental")
{
  stages <- usethis:::stages
  stage <- match.arg(tolower(stage), names(stages))

  kwb.utils::resolve(
    "url",
    grammars$lifecycle,
    stage = stage,
    colour = stages[[stage]]
  )
}

# is_on_cran -------------------------------------------------------------------

#' Helper function for checking if docu on CRAN
#' @keywords internal
#' @noRd
is_on_cran <- function(cran_link)
{
  try(httr::status_code(x = httr::GET(cran_link)) == 200, silent = TRUE)

  # tryCatch(httr::status_code(x = httr::GET(cran_link)) == 200,
  #   error = function(e) {
  #     print("caught error")
  #     cat(sprintf(
  #       "Requesting %s failed with an error:\n%s",
  #       cran_link, e
  #     ))
  #     "error"})
}

# use_badge_cran ---------------------------------------------------------------

#' Badge CRAN
#' @param pkgname name of R package (default: NULL)
#' @importFrom httr GET status_code
#' @return generates CRAN badge link
#' @importFrom assertthat is.error
#' @importFrom kwb.utils defaultIfNULL
#' @export
use_badge_cran <- function(pkgname = NULL)
{
  pkgname <- kwb.utils::defaultIfNULL(pkgname, get_pkgname(pkgname))

  cran_mirrors_link <- sapply(c("r-project", "rstudio"), function(org) {
    kwb.utils::resolve("url", grammars$mirror, org = org, pkgname = pkgname)
  })

  res_links <- sapply(cran_mirrors_link, kwb.pkgbuild:::is_on_cran)

  is_no_error <- sapply(res_links, assertthat::is.error)

  pkg_on_cran <- tryCatch(
    ifelse(! assertthat::is.error(res_link[1]), res_links[1], res_links[2]),
    error = function(e) {
      print("caught error")
      cat(sprintf(
        "Requesting %s and %s failed with an error:\n%s",
        res_links[1],
        res_links[2],
        e
      ))
    }
  )

  kwb.utils::resolve(
    "url",
    grammars$general,
    grammars$cran,
    href = if (pkg_on_cran) cran_mirrors_link[is_no_error][1] else ""
  )
}
