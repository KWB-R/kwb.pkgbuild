#
# This test file has been generated by kwb.test::create_test_files()
#

test_that("use_badge_cran() works", {

    expect_error({
    withr::with_dir(create_pkg_temp(), {kwb.pkgbuild:::use_badge_cran()})
    })

    kwb.pkgbuild:::use_badge_cran("kwb.hantush")


})
