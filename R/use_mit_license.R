#' Create MIT licence with KWB style
#'
#' @param copyright_holder list with name of copyright holder and additional
#' start_year (e.g. "2017") of copyright protection. If not specified
#' (start_year = NULL), the current year is used as year only!
#' (default: "list(name = kwb.pkgbuild:::kwb_string(), start_year = NULL)")
#' @return creates MIT licence file
#' @importFrom usethis use_mit_license
#' @importFrom fs file_copy
#' @importFrom kwb.utils catAndRun
#' @export
use_mit_license <- function(
    copyright_holder = list(name = kwb_string(), start_year = NULL)
)
{
  kwb.utils::catAndRun("Creating KWB MIT LICENSE/LICENSE.md files", {
    usethis::use_mit_license(copyright_holder = copyright_holder$name)
  })

  this_year <- format(Sys.Date(), format = "%Y")

  copyright_years <- ifelse(
    is.null(copyright_holder$start_year),
    this_year,
    sprintf("%s-%s", as.character(copyright_holder$start_year), this_year)
  )

  if (is.null(copyright_holder$start_year)) {
    return()
  }

  kwb.utils::catAndRun("Modifying start year in MIT LICENSE (CRAN version)", {
    writeLines(
      text = sprintf(
        "YEAR: %s\nCOPYRIGHT HOLDER: %s",
        copyright_years,
        copyright_holder$name
      ),
      con = "LICENSE"
    )
  })

  kwb.utils::catAndRun("Modifying start year in MIT LICENSE.md", {
    lic_txt <- readLines("LICENSE.md")
    index <- grep("^Copyright\\s+\\(c\\)", lic_txt)
    lic_txt[index] <- sprintf(
      "Copyright (c) %s %s",
      copyright_years,
      copyright_holder$name
    )
    writeLines(lic_txt, "LICENSE.md")
  })
}
