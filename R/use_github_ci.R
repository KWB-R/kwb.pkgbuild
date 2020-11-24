# use_ghactions-----------------------------------------------------------------

#' Adds default .github/workflows/
#' @return writes .github/workflows/ and adds it .Rbuildignore
#' @importFrom fs dir_copy
#' @export

use_ghactions <- function()
{

fs::dir_copy(path = system.file("templates/ci_github-actions/",
                                package = "kwb.pkgbuild"),
              new_path = ".github/workflows",
              overwrite = TRUE)

write_to_rbuildignore(ignore_pattern = "^\\.github$")
}
