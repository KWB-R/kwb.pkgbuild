# use_codecov ----------------------------------------------------------------
#' Adds codecov.yml
#' @return writes codecov.yml and adds it .Rbuildignore
#' @importFrom usethis use_coverage
#' @export
use_codecov <- function() {

 usethis::use_coverage(type = "codecov")
}
