#' pkgdown for KWB
#'
#' @param author list of author attributes (default: list(name = "Michael Rustler",
#' url = "https://mrustl.de"))
#' @param copyright_holder_name name of copyright holder
#' (default: "Kompetenzzentrum Wasser Berlin gGmbH (KWB)")
#' @return  performs usethis::use_pkgdown() and additionally writes _pkgdown.yml
#' based on KWB styling
#' @importFrom usethis use_pkgdown
#' @export
use_pkgdown <- function(
  author = list(name = "Michael Rustler", url = "http://mrustl.de"),
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
    authors = authors_yaml,
    template = list(params = list(bootswatch = "cerulean")),
    development = list(mode = "auto")
  ))

  writeLines(pkgdown_yaml, "_pkgdown.yml")

  write_to_rbuildignore("^_pkgdown\\.yml$")
}

kwb_string <- function() {
  "Kompetenzzentrum Wasser Berlin gGmbH (KWB)"
}
