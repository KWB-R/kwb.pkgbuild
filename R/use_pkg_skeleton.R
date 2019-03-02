# use_pkg_skeleton -------------------------------------------------------------

#' Use Package Skeleton
#' @param pkg_name name of R package
#' @return creates pkg skeleton in current working directory
#' @export
#' @importFrom usethis use_template use_git_ignore
#' @importFrom fs dir_create file_create
#' @importFrom desc desc_set
#' @examples
#' ## valid pkg folder
#' pkg_name <- "pkgname"
#' pkg_dir <- file.path(tempdir(), pkg_name)
#' pkg_dir <- create_pkg_dir(pkg_dir)
#' withr::with_dir(pkg_dir, {use_pkg_skeleton(pkg_name)})
use_pkg_skeleton <- function(pkg_name)
{
  if (is.null(pkg_name)) clean_stop(
    "Please specify a 'pkg_name'"
  )

  writeLines("", ".here")

  rproj_file <- paste0(pkg_name, ".Rproj")

  usethis::use_template("template.Rproj", rproj_file)

  usethis::use_git_ignore(".Rproj.user")

  if (usethis:::is_package()) {

    usethis::use_build_ignore(c(
      rproj_file,
      ".Rhistory",
      ".RData",
      ".Rproj.user" ,
      ".here"
    ))
  }

  fs::dir_create("R")
  fs::dir_create("man")
}
