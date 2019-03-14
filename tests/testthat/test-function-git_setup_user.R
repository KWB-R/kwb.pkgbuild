test_that("git_check_config() works", {
  skip_on_appveyor()
  expect_error(
    kwb.pkgbuild:::git_check_config()
  )

})

