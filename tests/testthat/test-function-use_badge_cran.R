#
# This test file has been generated by kwb.test::create_test_files()
#

test_that("use_badge_cran() works", {
    old_wd <- create_pkg_temp()
    kwb.pkgbuild:::use_badge_cran()
    setwd(old_wd)

    kwb.pkgbuild:::use_badge_cran("kwb.hantush")


})
