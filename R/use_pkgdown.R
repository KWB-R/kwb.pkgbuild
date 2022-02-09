#' pkgdown for KWB
#'
#' @param author list of author attributes (default:
#'   kwb.pkgbuild:::kwb_author("rustler"))
#' @param copyright_holder_name name of copyright holder
#' (default: kwb.pkgbuild:::kwb_string())
#' @param pkg name of KWB package (default: get_pkgname())
#' @param user name of GitHub user/organisation (default: 'kwb-r')
#' @param domain name of domain for webpage publishing (default: 'github')
#' @return  performs usethis::use_pkgdown() and additionally writes _pkgdown.yml
#' based on KWB styling
#' @importFrom usethis use_pkgdown
#' @importFrom kwb.utils isNaOrEmpty
#' @export
use_pkgdown <- function(
  author = kwb_author("rustler"),
  copyright_holder_name = kwb_string(),
  pkg = get_pkgname(),
  user = "kwb-r",
  domain = "github"
)
{
  usethis::use_pkgdown()

  pkgdown_url <- ""

  if(domain == "github" & !kwb.utils::isNaOrEmpty(pkg) & !kwb.utils::isNaOrEmpty(user)) {
  pkgdown_url <- yaml::as.yaml(list(url = sprintf("https://%s.github.io/%s",
                                                  tolower(user),
                                                  tolower(pkg$name)))
  )
  }

  authors <- stats::setNames(list(list(href = author$url)), author$name)

  if (copyright_holder_name == kwb_string()) {

    authors <- c(authors, stats::setNames(nm = copyright_holder_name, list(list(
      href = "http://www.kompetenz-wasser.de",
      html = paste0(
        "<img src='https://publications.kompetenz-wasser.de/img/KWB-Logo.svg",
        " alt='KWB' width='72' />")
    ))))
  }


  design <- list(bootstrap = 5L,
                 bootswatch = "cerulean",
                 bslib = list(bg = "#ffffff",
                              fg = "#000000",
                              primary = "#007aff",
                              `border-radius` = "0.5rem",
                              `btn-border-radius` = "0.25rem"))

  pkgdown_yaml <- yaml::as.yaml(list(
    authors = authors,
    template = design,
    development = list(mode = "auto")
  ))

  pkgdown_yaml <- paste0(pkgdown_url, pkgdown_yaml)

  writeLines(pkgdown_yaml, "_pkgdown.yml")

  write_to_rbuildignore("^_pkgdown\\.yml$")
}
