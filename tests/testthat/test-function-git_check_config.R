test_that("git_setup_user() works", {
  skip_on_appveyor()
  expect_error(
    kwb.pkgbuild:::git_setup_user("testuser", "test.user@doesnotmatter.eu")
  )

})

