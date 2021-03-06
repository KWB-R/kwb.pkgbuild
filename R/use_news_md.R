# use_news_md ------------------------------------------------------------------

#' Create KWB-styled "NEWS.md"
#'
#' @param news_txt text added to news (default: "* Added a 'NEWS.md' file to
#' track changes to the package.")
#' @param style_guide_url refer to tidyverse style website documenting how to
#' write a good "NEWS.md"(default: "https://style.tidyverse.org/news.html")
#' @return writes "NEWS.md" (in case it is not existing)
#' @importFrom fs file_exists
#' @export

use_news_md <- function(
  news_txt = "* Added a `NEWS.md` file to track changes to the package.",
  style_guide_url = "https://style.tidyverse.org/news.html"
)
{
  pkg <- read_description(file = "DESCRIPTION")

  style_guide_txt <- sprintf(
    "* see %s for writing a good `NEWS.md`",
    style_guide_url
  )

  news_txt <- sprintf(
    "# %s %s\n\n%s\n\n%s\n\n",
    pkg$name, pkg$version, news_txt, style_guide_txt
  )

  news_md <- "NEWS.md"

  if (fs::file_exists(news_md)) {
    warning(
      "No 'NEWS.md' created by kwb.pkgbuild::use_news_md(),\n",
      "because 'NEWS.md' is aleady existing. Please delete it first!"
    )
  } else {
    writeLines(news_txt, con = "NEWS.md")
  }
}
