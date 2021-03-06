#
# This test file has been generated by kwb.test::create_test_files()
#

test_that("use_description() works", {

  author <- kwb_author("rustler")
  author["orcid"] <- list(NULL)

  withr::with_dir(create_pkg_temp(), {
    kwb.pkgbuild:::use_description(author = author, funder = "BMBF")
  })
})
