#' @noRd
#' @keywords internal
#' @importFrom stringr str_split
#' @importFrom utils tail
check_pkg_dir_nested <- function(pkg_dir) {
  last_folders <- utils::tail(as.character(stringr::str_split(pkg_dir, pattern = "/",
                                                       simplify = TRUE)),
                       n = 2)
  if(last_folders[1] == last_folders[2]) {
    msg <- sprintf("Package skeleton for '%s' cannot be created, as it would be nested
in subfolder '%s'.\n\nWorkaround: specify a different 'root_dir' in function use_pkg_skeleton()",
                   last_folders[2], pkg_dir)
    stop(msg)
  } else {
    print(sprintf("%s is a valid 'root_dir' for pkg '%s'",
                  pkg_dir,
                  last_folders[2]))
    pkg_dir
  }
}


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

create_pkg_dir <- function(pkg_dir) {

 pkg_dir <- check_pkg_dir_nested(pkg_dir)

 if(fs::dir_exists(pkg_dir)) {
   n_files <- length(fs::dir_ls(pkg_dir))
   if (n_files > 0) {
     msg <- sprintf("%s cannot be created. It exits and contains %d files!",
                    pkg_dir,
                    n_files)
     stop(msg)
   } else {
     msg <- sprintf("%s cannot be created. It exists but contains %d files!",
                    pkg_dir,
                    n_files)
     warning(msg)
     pkg_dir
    }
 } else {
  fs::dir_create(pkg_dir,recursive = TRUE)
  pkg_dir
 }
}

