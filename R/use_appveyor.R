# read_gitlab_ci_template ------------------------------------------------------

#' @keywords internal
#' @noRd
ci_appveyor_template <- function()
{
  read_template("ci_appveyor.yml")
}


# write_ci_appveyor ------------------------------------------------------------

#' @keywords internal
#' @noRd
write_ci_appveyor <- function(yml_vector, dest_dir = getwd(), ignore)
{
  message <- add_creation_metadata()

  yml_vector <- c(message, yml_vector)

  message(sprintf("Writing: %s/appveyor.yml", dest_dir))
  writeLines(yml_vector, file.path(dest_dir, "appveyor.yml"))

  if (ignore) {
    write_to_rbuildignore(ignore_pattern = "^appveyor\\.yml$")
  }
}




# use_appveyor ----------------------------------------------------------------

# use_appveyor with KWB default style
#' Adds default appveyor.yml
#' @param dest_dir directoy to write (default: getwd())
#' @param yml_vector a yml imported as string vector (default:
#'   ci_appveyor_template())
#' @return writes appveyor.yml and adds it .Rbuildignore
#' @export
#'
use_appveyor <- function(
dest_dir = getwd(), yml_vector = ci_appveyor_template()
)
{
  write_ci_appveyor(yml_vector, dest_dir = dest_dir, ignore = TRUE)
}
