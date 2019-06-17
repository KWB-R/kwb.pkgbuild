test_that("use_badge_lifecycle() works", {

  expect_identical(
    kwb.pkgbuild:::use_badge_lifecycle("experimental"),
    paste0(
      "[![Project Status](https://img.shields.io/badge/lifecycle-experimental",
      "-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)"
    )
  )

})
