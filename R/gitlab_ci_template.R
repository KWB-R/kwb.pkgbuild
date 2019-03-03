# gitlab_ci_template_docs ------------------------------------------------------

#' @keywords internal
# ' @noRd
gitlab_ci_template_docs <- function()
{
  read_gitlab_ci_template("gitlab_ci_template_docs.yml")
}

# gitlab_ci_template_ghpages ---------------------------------------------------

#' @keywords internal
#' @noRd
gitlab_ci_template_ghpages <- function()
{
  read_gitlab_ci_template("gitlab_ci_template_ghpages.yml")
}

# gitlab_ci_template_pkgdown ---------------------------------------------------

#' @keywords internal
#' @noRd
gitlab_ci_template_pkgdown <- function()
{
  read_gitlab_ci_template("gitlab_ci_template_pkgdown.yml")
}

# gitlab_ci_template_blogdown --------------------------------------------------

#' @keywords internal
#' @noRd
gitlab_ci_template_blogdown <- function()
{
  read_gitlab_ci_template("gitlab_ci_template_blogdown.yml")
}

# read_gitlab_ci_template ------------------------------------------------------

#' @keywords internal
#' @noRd
read_gitlab_ci_template <- function(name)
{
  yml <- system.file(sprintf("templates/%s", name), package = "kwb.pkgbuild")

  readLines(yml)
}
