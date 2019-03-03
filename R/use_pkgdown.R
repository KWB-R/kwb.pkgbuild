#' pkgdown for KWB
#'
#' @param author list of author attributes (default:
#'   kwb.pkgbuild:::kwb_author("rustler"))
#' @param copyright_holder_name name of copyright holder
#' (default: kwb.pkgbuild:::kwb_string())
#' @return  performs usethis::use_pkgdown() and additionally writes _pkgdown.yml
#' based on KWB styling
#' @importFrom usethis use_pkgdown
#' @export
use_pkgdown <- function(
  author = kwb_author("rustler"),
  copyright_holder_name = kwb_string()
)
{
  usethis::use_pkgdown()

  authors <- stats::setNames(list(list(href = author$url)), author$name)

  if (copyright_holder_name == kwb_string()) {

    authors <- c(authors, stats::setNames(nm = copyright_holder_name, list(list(
      href = "http://www.kompetenz-wasser.de",
      html = paste0(
        "<img src='http://www.kompetenz-wasser.de/wp-content/uploads/",
        "2017/08/cropped-logo-kwb_klein-new.png' height='24' />")
    ))))
  }

  pkgdown_yaml <- yaml::as.yaml(list(
    authors = authors,
    template = list(params = list(bootswatch = "cerulean")),
    development = list(mode = "auto")
  ))

  writeLines(pkgdown_yaml, "_pkgdown.yml")

  write_to_rbuildignore("^_pkgdown\\.yml$")
}
