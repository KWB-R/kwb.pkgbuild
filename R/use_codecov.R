# use_codecov ----------------------------------------------------------------
#' Adds codecov.yml
#' @return writes codecov.yml and adds it .Rbuildignore
#' @importFrom usethis use_template
#' @export
use_codecov <- function() {

  usethis:::check_uses_travis()
  type <- "codecov"
  usethis:::use_dependency("covr", "Suggests")
  if (type == "codecov") {
    new <- usethis::use_template("codecov.yml", ignore = TRUE)
    if (!new)
      return(invisible(FALSE))
  }
  message("Add codecov to '.travis.yml'")
  usethis:::code_block("after_success:", "  - Rscript -e 'covr::{type}()'")
  invisible(TRUE)

}
