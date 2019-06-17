# read_travis_ci_template ------------------------------------------------------

#' @keywords internal
#' @noRd
ci_travis_template <- function()
{
  read_template("ci_travis.yml")
}

# write_ci_travis --------------------------------------------------------------

#' @keywords internal
#' @noRd
write_ci_travis <- function(yml_vector, dest_dir = getwd(), ignore)
{
  message <- add_creation_metadata()

  yml_vector <- c(message, yml_vector)

  message(sprintf("Writing: %s/.travis.yml", dest_dir))
  writeLines(yml_vector, file.path(dest_dir, ".travis.yml"))

  if (ignore) {
    write_to_rbuildignore(ignore_pattern = "^\\.travis\\.yml$")
  }
}



# use_travis -------------------------------------------------------------------

#' Adds default .travis.yml
#' @param auto_build_pkgdown  prepare Travis for pkgdown::build_site()
#' (default: FALSE)
#' @param dbg print debug messages (default: TRUE)
#' @param yml_vector a yml imported as string vector (default:
#' ci_travis_template())
#' @return writes .travis.yml and adds it .Rbuildignore
#' @importFrom yaml as.yaml write_yaml
#' @export

use_travis <- function(auto_build_pkgdown = FALSE, dbg = TRUE,
                       yml_vector = ci_travis_template())
{
  travis_yml <- ".travis.yml"

  if (fs::file_exists(travis_yml)) {

    kwb.utils::catAndRun(
      dbg = dbg,
      messageText = sprintf("Deleting existing '%s'\n", travis_yml),
      expr = fs::file_delete(travis_yml)
    )
  }

  write_ci_travis(yml_vector, ignore = TRUE)
}
