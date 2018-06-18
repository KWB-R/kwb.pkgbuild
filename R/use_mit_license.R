#' Create MIT licence with KWB style
#'
#' @param copyright_holder list with name of copyright holder and additional
#' start_year (e.g. "2017") of copyright protection. If not specified
#' (start_year = NULL), the current year is used as year only!
#' (default: "list(name ="Kompetenzzentrum Wasser Berlin gGmbH (KWB)",
#' start_year = NULL)")
#' @return creates MIT licence file
#' @importFrom usethis use_mit_license
#' @importFrom stringr str_detect
#' @importFrom fs file_copy
#' @export
use_mit_license <- function(
  copyright_holder = list(name ="Kompetenzzentrum Wasser Berlin gGmbH (KWB)",
                          start_year = NULL)) {

cat("Creating KWB MIT LICENSE file....\n")
usethis::use_mit_license(name = copyright_holder$name)

if (!is.null(copyright_holder$start_year)) {

  lic_txt <- readLines("LICENSE.md")
  index <- stringr::str_detect(lic_txt,pattern = "^Copyright\\s+\\(c\\)")

  cpy_holder <- sprintf("Copyright (c) %s-%s %s",
                      as.character(copyright_holder$start_year),
                      format(Sys.Date(), format = "%Y"),
                      copyright_holder$name)

  lic_txt[index] <- cpy_holder
  writeLines(lic_txt, "LICENSE.md")
 }

fs::file_copy(path = "LICENSE.md", new_path = "LICENSE",overwrite = TRUE)
cat("Creating MIT LICENSE file....done.\n")
}
