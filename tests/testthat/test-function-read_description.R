#
# This test file has been generated by kwb.test::create_test_files()
#

test_that("read_description() works", {

  expect_error(
    kwb.pkgbuild:::read_description()
  )

  old_wd <- create_pkg_temp()
  kwb.pkgbuild:::read_description()
  setwd(old_wd)


})
