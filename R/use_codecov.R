# use_codecov ----------------------------------------------------------------

#' Adds codecov.yml
#' @return writes codecov.yml and adds it .Rbuildignore
#' @importFrom usethis use_template
#' @export
use_codecov <- function()
{
  usethis:::check_uses_github_actions()
  usethis:::use_dependency("covr", "Suggests")

  if (! usethis::use_template("codecov.yml", ignore = TRUE)) {
    return(invisible(FALSE))
  }
}
