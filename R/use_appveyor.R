# use_appveyor with KWB default style
#' Adds default .appveyor.yml
#' @importFrom utils download.file
#' @return writes .appveyor.yml and adds it .Rbuildignore
#' @export

use_appveyor <- function() {

### Using appveyor.yml from readxl as template:
utils::download.file(url = paste0("https://raw.githubusercontent.com/",
"tidyverse/readxl/5649e2643d25bb5b6353797fc48bbcbb0eb72f6d/appveyor.yml"),
destfile = "appveyor.yml")



ignored_files <- readLines(".Rbuildignore")

appveyor_ci_pat <- "^appveyor\\.yml$"
has_appveyor_yml <- any(grepl(x = ignored_files, pattern = appveyor_ci_pat,
                              fixed = TRUE))

if (! has_appveyor_yml) {
  ignored_files <- append(x = ignored_files, values = "^appveyor\\.yml$")
  writeLines(text = ignored_files,
             con = ".Rbuildignore")
}


}
