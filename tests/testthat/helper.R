## Helper for creating temporary R package
create_pkg_temp <- function() {
number <- sample(x = 1:10000000,size = 1)
root_dir <- paste0(stringr::str_replace_all(tempdir(),"\\\\", "/"),
            sprintf("%d", number))
pkg_name <- "testpkg"
pkg_dir <- file.path(root_dir, pkg_name)
kwb.pkgbuild::create_pkg_dir(pkg_dir)
withr::with_dir(pkg_dir, {kwb.pkgbuild::use_pkg_skeleton(pkg_name)})
pkg_dir
}

# create_pkg_temp <- function(root_dir = tempdir()) {
# pkg_name <- sprintf("testpkg%s", sample(1:10000,1))
# pkg_path <- file.path(root_dir, pkg_name)
# kwb.pkgbuild::create_pkg_dir(pkg_path)
# withr::with_dir(pkg_path, {kwb.pkgbuild::use_pkg_skeleton(pkg_name)
#   })
# pkg_path
#
# }
