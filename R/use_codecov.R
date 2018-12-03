# use_codecov ----------------------------------------------------------------
#' Adds codecov.yml
#' @return writes codecov.yml and adds it .Rbuildignore
#' @importFrom usethis use_template
#' @export
use_codecov <- function() {

  usethis:::check_uses_travis()
  usethis:::use_dependency("covr", "Suggests")
  new <- usethis::use_template("codecov.yml", ignore = TRUE)
    if (!new) {
      return(invisible(FALSE))
    }
}
