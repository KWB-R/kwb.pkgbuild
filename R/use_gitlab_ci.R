# use_gitlab_ci_docs -----------------------------------------------------------

#' Adds .gitlab-ci.yml (if repo contains a "docs" subfolder)
#'
#' @param dest_dir directoy to write (default: getwd())
#' @param yml_vector a yml imported as string vector (default:
#'   gitlab_ci_template_docs())
#' @return writes .gitlab-ci.yml and adds it .Rbuildignore
#' @importFrom fs file_exists
#' @export

use_gitlab_ci_docs <- function(
  dest_dir = getwd(), yml_vector = gitlab_ci_template_docs()
)
{
  if (dir.exists("docs")) {

    write_gitlab_ci(yml_vector, dest_dir = dest_dir, ignore = TRUE)

  } else {

    warning("No 'docs' folder, no .gitlab-ci.yml created!")
  }
}

# use_gitlab_ci_ghpages---------------------------------------------------------

#' Adds .gitlab-ci.yml (which should be saved in root dir of "gh-pages" branch)
#' @param dest_dir directoy to write (default:
#' getwd())
#' @param yml_vector a yml imported as string vector (default: gitlab_ci_template_ghpages())
#' @return writes .gitlab-ci.yml
#' @importFrom fs file_exists
#' @export

use_gitlab_ci_ghpages <- function(
  dest_dir = getwd(), yml_vector = gitlab_ci_template_ghpages()
)
{
  write_gitlab_ci(yml_vector, dest_dir = dest_dir, ignore = FALSE)
}

# use_gitlab_ci_blogdown--------------------------------------------------------

#' Adds .gitlab-ci.yml (if repo contains on root in a "gh-pages" branch)
#' @param dest_dir directoy to write (default: getwd())
#' @param yml_vector a yml imported as string vector (default:
#'   gitlab_ci_template_blogdown())
#' @return writes .gitlab-ci.yml
#' @importFrom fs file_exists
#' @export

use_gitlab_ci_blogdown <- function(
  dest_dir = getwd(), yml_vector = gitlab_ci_template_blogdown()
)
{
  write_gitlab_ci(yml_vector, dest_dir = dest_dir, ignore = TRUE)
}

# use_gitlab_ci_pkgdown---------------------------------------------------------

#' Adds .gitlab-ci.yml
#'
#' @param dest_dir directoy to write (default: getwd())
#' @param yml_vector a yml imported as string vector (default:
#'   gitlab_ci_template_pkgdown(), where "<owner>/<repo>" is replaced with value
#'   from DESCRIPTION specified in field URL, e.g.
#'   https://github.com/KWB-R/kwb.pkgbuild" sets "KWB-R/kwb.pkgbuild" as
#'   "<owner>/<repo>")
#' @return writes .gitlab-ci.yml
#' @importFrom stringr str_remove
#' @importFrom desc desc_get
#' @export

use_gitlab_ci_pkgdown <- function(
  dest_dir = getwd(), yml_vector = gitlab_ci_template_pkgdown()
)
{
  repo <- stringr::str_remove(desc::desc_get("URL"), "^http(s)?://github.com/")

  yml_vector <- stringr::str_replace(yml_vector, "<owner>/<repo>", repo)

  write_gitlab_ci(yml_vector, dest_dir = dest_dir, ignore = TRUE)
}


# write_gitlab_ci --------------------------------------------------------------

#' @keywords internal
#' @noRd
write_gitlab_ci <- function(yml_vector, dest_dir = getwd(), ignore)
{
  message <- add_creation_metadata()

  yml_vector <- c(message, yml_vector)

  writeLines(yml_vector, file.path(dest_dir, ".gitlab-ci.yml"))

  if (ignore) {
    write_to_rbuildignore(ignore_pattern = "^.gitlab-ci\\.yml$")
  }
}
