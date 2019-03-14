# use_installation -------------------------------------------------------------

#' Helper function: describe pkg installation in index.Rmd / README.md
#'
#' @param pkgname package name
#' @param user user name or organisation under which repository defined in
#' parameter "repo" is hosted
#' @param domain under which repository is hosted
#' @param output  if "rmd" (other code chunks are used); otherwise: "md" style!
#' (default: "md")
use_installation <- function(pkgname, user, domain, output = "md")
{

  url_tutorial_install <- "https://kwb-r.github.io/kwb.pkgbuild/articles/install.html"

  c("## Installation",
    "",
    paste("For more details on how to install KWB-R packages checkout our",
          sprintf("[installation tutorial](%s).", url_tutorial_install)),
    "",
    if (tolower(output) == "rmd") {
      "```{r echo = TRUE, eval = FALSE}"
    } else {
      "```r"
    },
    '### Option: specify GitHub Personal Access Token (GITHUB_PAT)',
    '### see: https://kwb-r.github.io/kwb.pkgbuild/articles/install.html#set-your-github_pat',
    '### why this might be important for you!',
    '',
    '#Sys.setenv(GITHUB_PAT = "mysecret_access_token")',
    '',
    'if (!require("remotes")) {',
    'install.packages("remotes", repos = "https://cloud.r-project.org")',
    '}',
    '',
    "### Temporal workaround to due bug in latest CRAN of R package remotes v2.0.2",
    "### on Windows(for details: see https://github.com/r-lib/remotes/issues/248)",
    '',
    'remotes::install_github("r-lib/remotes@18c7302637053faf21c5b025e1e9243962db1bdc")',
    sprintf("remotes::install_%s(\"%s/%s\")", domain, user, pkgname),
    "```"
  )
}
