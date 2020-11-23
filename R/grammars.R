# grammars ---------------------------------------------------------------------

grammars <- list(
  general = list(
    url = "[![<title>](<src>)](<href>)",
    src = "<address>/<path_1><params>",
    href = "<address>/<path_2>",
    branch = "main"
  ),
  appveyor = list(
    title = "Appveyor build Status",
    address = "https://ci.appveyor.com",
    path_1 = "api/projects/status/<domain>/<user>/<pkgname>",
    path_2 = "project/<user>/<pkgname_dash>/branch/<branch>",
    params = "?branch=<branch>&svg=true"
  ),
  travis = list(
    title = "Travis build Status",
    address = "https://travis-ci.com",
    path_1 = "<path_2>.svg?branch=<branch>",
    path_2 = "<user>/<pkgname>",
    params = ""
  ),
  ghactions_rcmdcheck = list(
    title = "R-CMD-check",
    address = "https://github.com",
    path_1 = "<path_2>/workflows/R-CMD-check/badge.svg",
    path_2 = "<user>/<pkgname>/actions?query=workflow%3A<title>",
    params = ""
  ),
  ghactions_pkgdown = list(
    title = "pkgdown",
    address = "https://github.com",
    path_1 = "<path_2>/workflows/R-CMD-check/badge.svg",
    path_2 = "<user>/<pkgname>/actions?query=workflow%3A<title>",
    params = ""
  ),
  codecov = list(
    title = "codecov",
    address = "https://codecov.io",
    path_1 = "<path_2>/branch/<branch>/graphs/badge.svg",
    path_2 = "<domain>/<user>/<pkgname>",
    params = ""
  ),
  lifecycle = list(
    title = "Project Status",
    src = "https://img.shields.io/badge/lifecycle-<stage>-<colour>.svg",
    href = "https://www.tidyverse.org/lifecycle/#<stage>"
  ),
  cran = list(
    title = "CRAN_Status_Badge",
    src = "https://www.r-pkg.org/badges/version/<pkgname>"
  ),
  mirror = list(
    url = "https://cran.<org>.org/package=<pkgname>"
  )
)
