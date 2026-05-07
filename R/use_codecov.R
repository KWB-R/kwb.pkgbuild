# use_codecov ----------------------------------------------------------------

#' Adds codecov.yml
#' @return writes codecov.yml and adds it .Rbuildignore
#' @importFrom usethis use_template
#' @export
use_codecov <- function()
{
  getFromNamespace("check_uses_github_actions", "usethis")()
  getFromNamespace("use_dependency", "usethis")("covr", "Suggests")

  if (! usethis::use_template("codecov.yml", ignore = TRUE)) {
    return(invisible(FALSE))
  }
}
