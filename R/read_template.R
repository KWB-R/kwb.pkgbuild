# read_template ------------------------------------------------------

#' @keywords internal
#' @noRd
read_template <- function(name)
{
  template <- system.file(sprintf("templates/%s", name), package = "kwb.pkgbuild")

  readLines(template)
}
