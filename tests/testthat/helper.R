### Helper for creating temporary R package
create_pkg_temp <- function() {
number <- sample(x = 1:10000000,size = 1)
path = file.path(tempdir(), sprintf("testpkg%d", number))
pkg_temp <- fs::dir_create(path)
old_wd <- setwd(dir = pkg_temp)
usethis::create_package(pkg_temp,rstudio = FALSE, open = FALSE)
return(old_wd)
}

