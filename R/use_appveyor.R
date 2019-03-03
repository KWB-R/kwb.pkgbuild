# use_appveyor ----------------------------------------------------------------

# use_appveyor with KWB default style
#' Adds default .appveyor.yml
#' @importFrom utils download.file
#' @return writes .appveyor.yml and adds it .Rbuildignore
#' @export

use_appveyor <- function()
{
  # URL to appveyor.yml from tidyverse/readxl to be used as a template
  url <- paste0(
    "https://raw.githubusercontent.com/",
    "tidyverse/readxl/5649e2643d25bb5b6353797fc48bbcbb0eb72f6d/appveyor.yml"
  )

  utils::download.file(url, destfile = "appveyor.yml")

  write_to_rbuildignore(ignore_pattern = "^appveyor\\.yml$")
}
