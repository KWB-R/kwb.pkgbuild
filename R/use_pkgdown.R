#' Set up `pkgdown` with KWB styling
#'
#' Calls `usethis::use_pkgdown()` and additionally writes a `_pkgdown.yml`
#' configured with KWB defaults (Bootstrap 5 + cerulean theme, KWB authors
#' block, copyright holder logo).
#'
#' @param author list of author attributes (default:
#'   kwb.pkgbuild:::kwb_author("rustler"))
#' @param copyright_holder_name name of copyright holder
#'   (default: kwb.pkgbuild:::kwb_string())
#' @param pkg name of KWB package (default: get_pkgname())
#' @param user name of GitHub user/organisation (default: 'kwb-r')
#' @param domain name of domain for webpage publishing (default: 'github')
#' @return invisibly; as a side effect writes `_pkgdown.yml` with KWB styling
#'   and adds it to `.Rbuildignore`.
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
                                                  tolower(pkg)))
  )
  }

  authors <- stats::setNames(list(list(href = author$url)), author$name)

  if (copyright_holder_name == kwb_string()) {

    authors <- c(authors, stats::setNames(nm = copyright_holder_name, list(list(
      href = "http://www.kompetenz-wasser.de",
      html = paste0(
        "<img src='https://logos.kompetenz-wasser.io/KWB_Logo_M_Blau_RGB.svg'",
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
