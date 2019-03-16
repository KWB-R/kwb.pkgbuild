test_that("use_badge_cran() works", {

  expect_error(withr::with_dir(create_pkg_temp(), {
    kwb.pkgbuild:::use_badge_cran()
  }))

  expect_identical(
    kwb.pkgbuild:::use_badge_cran("kwb.hantush"),
    paste0(
      "[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/",
      "kwb.hantush)](https://cran.r-project.org/package=kwb.hantush)"
    )
  )

  expect_identical(
    kwb.pkgbuild:::use_badge_cran("does_not_exist"),
    paste0(
      "[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/",
      "does_not_exist)]()"
    )
  )
})
