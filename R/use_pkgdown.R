#' pkgdown for KWB
#'
#' @param author list of author attributes (default: list(name = "Michael Rustler",
#' url = "http://mrustl.de"))
#' @param copyright_holder_name name of copyright holder
#' (default: "Kompetenzzentrum Wasser Berlin gGmbH (KWB)")
#' @return  performs usethis::use_pkgdown() and additionally writes _pkgdown.yml
#' based on KWB styling
#' @importFrom usethis use_pkgdown
#' @export
use_pkgdown <- function(author = list(name = "Michael Rustler",
                                      url = "http://mrustl.de"),
copyright_holder_name = "Kompetenzzentrum Wasser Berlin gGmbH (KWB)") {


usethis::use_pkgdown()

authors_yml <- list(x1 = list(href = author$url))
names(authors_yml) <- author$name

pkgdown_authors_yaml <-  authors_yml

if(copyright_holder_name == "Kompetenzzentrum Wasser Berlin gGmbH (KWB)") {

kwb_yml <- list(x1 =
list(href = "http://www.kompetenz-wasser.de",
html = paste0("<img src='http://www.kompetenz-wasser.de/wp-content/uploads/",
              "2017/08/cropped-logo-kwb_klein-new.png' height='24' />")))
names(kwb_yml) <- copyright_holder_name

pkgdown_authors_yaml <- c(authors_yml, kwb_yml)

}


pkgdown_yaml <- yaml::as.yaml(list(authors = pkgdown_authors_yaml,
                       template = list(params = list(bootswatch = "cerulean")),
                       development = list(mode = "auto")))

writeLines(pkgdown_yaml,con = "_pkgdown.yml")

write_to_rbuildignore(ignore_pattern = "^_pkgdown\\.yml$")
}
