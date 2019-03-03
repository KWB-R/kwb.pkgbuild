# create_pkg_dir ---------------------------------------------------------------

#' Create Package Directory
#'
#' @param pkg_dir path to package directory to be created, including the
#' pkgname as last folder
#' @return creates directory for package if not existing
#' @importFrom fs dir_ls dir_create
#' @export
#' @examples
#' ## not a valid pkg folder
#' \dontrun{
#' pkg_dir <- file.path(tempdir(), "pkgname/pkgname")
#' create_pkg_dir(pkg_dir)
#' }
#' ## valid pkg folder
#' pkg_dir <- file.path(tempdir(), "pkgname")
#' create_pkg_dir(pkg_dir)

create_pkg_dir <- function(pkg_dir)
{
  pkg_dir <- check_pkg_dir_nested(pkg_dir)

  # If the directory does not exist, create it and return
  if (! fs::dir_exists(pkg_dir)) {
    fs::dir_create(pkg_dir, recursive = TRUE)
    return(pkg_dir)
  }

  # Directory exists
  n_files <- length(fs::dir_ls(pkg_dir))

  if (n_files > 0) clean_stop(sprintf(
    "%s cannot be created. It exits and contains %d files!", pkg_dir, n_files
  ))

  warning(sprintf("%s cannot be created. It exists and is empty.", pkg_dir))

  pkg_dir
}

# check_pkg_dir_nested ---------------------------------------------------------

#' @noRd
#' @keywords internal
#' @importFrom stringr str_split
#' @importFrom utils tail
check_pkg_dir_nested <- function(pkg_dir)
{
  last_folders <- utils::tail(n = 2, as.character(
    stringr::str_split(pkg_dir, pattern = "/", simplify = TRUE)
  ))

  if (last_folders[1] == last_folders[2]) clean_stop(
    sprintf("Package skeleton for '%s' cannot be created, ", last_folders[2]),
    sprintf("as it would be nested in subfolder '%s'.\n\n", pkg_dir),
    "Workaround: specify a different 'root_dir' in function use_pkg_skeleton()"
  )

  message(sprintf(
    "%s is a valid 'root_dir' for pkg '%s'", pkg_dir, last_folders[2]
  ))

  pkg_dir
}
