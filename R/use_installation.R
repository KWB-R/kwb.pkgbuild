# use_installation -------------------------------------------------------------

#' Helper: describe pkg installation in index.md / README.md
#'
#' @param pkgname package name
#' @param user user/organisation hosting the repository
#' @param domain under which repository is hosted (e.g. "github")
#' @return character vector with markdown lines for the installation section
#' @keywords internal
#' @noRd
use_installation <- function(pkgname, user, domain)
{
  url_tutorial_install <-
    "https://kwb-r.github.io/kwb.pkgbuild/articles/install.html"

  c(
    "## Installation",
    "",
    paste(
      "For details on how to install KWB-R packages checkout our",
      sprintf("[installation tutorial](%s).", url_tutorial_install)
    ),
    "",
    "```r",
    '### Optionally: specify GitHub Personal Access Token (GITHUB_PAT)',
    '### See here why this might be important for you:',
    '### https://kwb-r.github.io/kwb.pkgbuild/articles/install.html#set-your-github_pat',
    '',
    '# Sys.setenv(GITHUB_PAT = "mysecret_access_token")',
    '',
    '# Install package "remotes" from CRAN',
    'if (! require("remotes")) {',
    '  install.packages("remotes", repos = "https://cloud.r-project.org")',
    '}',
    '',
    sprintf("# Install KWB package '%s' from GitHub", pkgname),
    sprintf("remotes::install_%s(\"%s/%s\")", domain, user, pkgname),
    "```"
  )
}
