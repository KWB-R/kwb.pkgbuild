#' Create KWB-styled "NEWS.md"
#'
#' @param pkg_name name of the R package (e.g. kwb.pkgbuild)
#' @param pkg_version version of the package
#' @param news_txt text added to news (default: "* Added a 'NEWS.md' file to
#' track changes to the package.")
#' @param style_guide_url refer to tidyverse style website documenting how to
#' write a good "NEWS.md"(default: "http://style.tidyverse.org/news.html")
#'
#' @return writes "NEWS.md"
#' @export
#'
#' @examples
#' kwb.pkgbuild::use_news_md(
#' pkg_name = "kwb.geosalz",
#' pkg_version = "0.1.0.9000")
#'
use_news_md <- function(pkg_name,
                        pkg_version,
news_txt = "* Added a `NEWS.md` file to track changes to the package.",
style_guide_url = "http://style.tidyverse.org/news.html") {

  style_guide_txt <- sprintf("* see %s for writing a good `NEWS.md`",
                              style_guide_url)


  news_txt <- sprintf("# %s %s\n\n%s\n\n%s\n\n",
          pkg_name,
          pkg_version,
          news_txt,
          style_guide_txt
          )

  writeLines(news_txt, con = "NEWS.md")
}
