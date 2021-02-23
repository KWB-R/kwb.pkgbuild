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

# use_badge_ghactions_rcmdcheck ------------------------------------------------

#' Badge Github Actions RCMD Check
#' @param repo name of repository (default: NULL)
#' @param user user name or organisation under which repository defined in
#' parameter "repo" is hosted (default: KWB-R")
#' @param branch default: NULL (i.e. use "default" branch) or user defined branch
#' (e.g. "dev")
#' @return generates travis badge link
#' @export
use_badge_ghactions_rcmdcheck <- function(repo = NULL, user = "KWB-R",
                                          branch = NULL)
{
  kwb.utils::resolve(
    "url",
    grammars$general,
    grammars$ghactions_rcmdcheck,
    user = user,
    pkgname = get_pkgname(repo),
    params = ifelse(is.null(branch), "", sprintf("?branch=%s", branch))

  )

}

#' Badge Github Actions Pkgdown
#' @param repo name of repository (default: NULL)
#' @param user user name or organisation under which repository defined in
#' parameter "repo" is hosted (default: KWB-R")
#' @param branch default: NULL (i.e. use "default" branch) or user defined branch
#' (e.g. "dev")
#' @return generates Github Actions Pkgdown badge link
#' @export
use_badge_ghactions_pkgdown <- function(repo = NULL, user = "KWB-R", branch = NULL)
{
  kwb.utils::resolve(
    "url",
    grammars$general,
    grammars$ghactions_pkgdown,
    user = user,
    pkgname = get_pkgname(repo),
    params = ifelse(is.null(branch), "", sprintf("?branch=%s", branch))
  )

}

# use_badge_ghactions ----------------------------------------------------------

#' Badge Github Actions
#' @param repo name of repository (default: NULL)
#' @param user user name or organisation under which repository defined in
#' parameter "repo" is hosted (default: KWB-R")
#' @param branch default: NULL (i.e. use "default" branch) or user defined branch
#' (e.g. "dev")
#' @return generates Github Actions badges link
#' @export
#' @importFrom clipr write_clip
use_badge_ghactions <- function(repo = NULL, user = "KWB-R", branch = NULL)
{
  badge_md <- sprintf("%s\n%s",
                      use_badge_ghactions_rcmdcheck(repo, user, branch),
                      use_badge_ghactions_pkgdown(repo, user, branch)
                      )
  cat(badge_md)
  message("Badges were also copied to clipboard (use STRG + V to insert!)")
  clipr::write_clip(badge_md, allow_non_interactive = TRUE)
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
    grammars$general,
    grammars$lifecycle,
    stage = stage,
    colour = stages[[stage]]
  )
}

# use_badge_cran ---------------------------------------------------------------

#' Badge CRAN
#' @param pkgname name of R package (default: NULL)
#' @importFrom httr GET status_code
#' @return generates CRAN badge link
#' @importFrom kwb.utils defaultIfNULL
#' @export
use_badge_cran <- function(pkgname = NULL)
{
  pkgname <- kwb.utils::defaultIfNULL(pkgname, get_pkgname(pkgname))

  cran_mirrors_link <- sapply(c("r-project", "rstudio"), function(org) {
    kwb.utils::resolve("url", grammars$mirror, org = org, pkgname = pkgname)
  })

  # Indices of cran links that exist
  indices <- which(is_on_cran(cran_mirrors_link))

  href <- if (length(indices)) {
    cran_mirrors_link[indices[1]]
  } else {
    ""
  }

  kwb.utils::resolve(
    "url", grammars$general, grammars$cran, pkgname = pkgname, href = href
  )
}

# is_on_cran -------------------------------------------------------------------

#' Helper function for checking if docu on CRAN
#' @keywords internal
#' @noRd
is_on_cran <- function(cran_link)
{
  stopifnot(is.character(cran_link))

  # Call this function for all elements if there is more than one element
  if (length(cran_link) > 1) {
    return(sapply(cran_link, is_on_cran))
  }

  cran_link <- cran_link[1]

  x <- try(httr::GET(cran_link), silent = TRUE)

  errored <- inherits(x, "try-error")

  if (errored) message(sprintf(
    "Requesting %s failed with:\n%s", cran_link, attr(x, "condition")$message
  ))

  ! errored && httr::status_code(x) == 200
}
