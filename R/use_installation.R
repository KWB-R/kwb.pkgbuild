#' Helper function: describe pkg installation in index.Rmd / README.md
#' @param pkgname package name
#' @param user user name or organisation under which repository defined in
#' parameter "repo" is hosted
#' @param domain under which repository is hosted
use_installation <- function(pkgname, user, domain) {

  c("# Installation",
    "",
    "```{r echo = TRUE, eval = FALSE}",
    "#install.packages(\"devtools\", repos = \"https://cloud.r-project.org\")",
    sprintf("devtools::install_%s(\"%s/%s)",
            domain,
            user,
            pkgname),
    "```")

}
