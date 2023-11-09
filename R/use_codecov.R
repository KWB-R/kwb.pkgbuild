# use_codecov ----------------------------------------------------------------

#' Adds codecov.yml
#' @return writes codecov.yml and adds it .Rbuildignore
#' @importFrom usethis use_template
#' @importFrom utils getFromNamespace
#' @export
use_codecov <- function()
{
  utils::getFromNamespace("check_uses_github_actions", "usethis")()
  utils::getFromNamespace("use_dependency", "usethis")("covr", "Suggests")

  if (! usethis::use_template("codecov.yml", ignore = TRUE)) {
    return(invisible(FALSE))
  }
}
