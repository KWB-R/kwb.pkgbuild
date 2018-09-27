#' Helper function: describe pkg installation in index.Rmd / README.md
#' @param pkgname package name
#' @param user user name or organisation under which repository defined in
#' parameter "repo" is hosted
#' @param domain under which repository is hosted
#' @param output  if "rmd" (other code chunks are used); otherwise: "md" style!
#' (default: "md")
use_installation <- function(pkgname, user, domain, output = "md")
{
  c("## Installation",
    "",
    if (tolower(output) == "rmd") {
      "```{r echo = TRUE, eval = FALSE}"
    } else {
      "```r"
    },
    "#install.packages(\"devtools\", repos = \"https://cloud.r-project.org\")",
    sprintf("devtools::install_%s(\"%s/%s\")", domain, user, pkgname),
    "```")
}
