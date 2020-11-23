# use_ghactions-----------------------------------------------------------------

#' Adds default .github/workflows/
#' @return writes .github/workflows/ and adds it .Rbuildignore
#' @importFrom fs file_copy
#' @export

use_ghactions <- function()
{

fs::file_copy(path = "templates/ci_github-actions/",
              new_path = ".github/workflows",
              overwrite = TRUE)

write_to_rbuildignore(ignore_pattern = "^\\.github$")
}
