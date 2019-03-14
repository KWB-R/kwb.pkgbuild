test_that("git_setup_user() works", {

  expect_(
    kwb.pkgbuild:::git_setup_user("testuser", "test.user@doesnotmatter.eu")
  )

})

