[![R-CMD-check](https://github.com/KWB-R/kwb.pkgbuild/workflows/R-CMD-check/badge.svg)](https://github.com/KWB-R/kwb.pkgbuild/actions?query=workflow%3AR-CMD-check)
[![pkgdown](https://github.com/KWB-R/kwb.pkgbuild/workflows/pkgdown/badge.svg)](https://github.com/KWB-R/kwb.pkgbuild/actions?query=workflow%3Apkgdown)
[![codecov](https://codecov.io/github/KWB-R/kwb.pkgbuild/branch/main/graphs/badge.svg)](https://codecov.io/github/KWB-R/kwb.pkgbuild)
[![Project Status](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/kwb.pkgbuild)]()
[![R-Universe_Status_Badge](https://kwb-r.r-universe.dev/badges/kwb.pkgbuild)](https://kwb-r.r-universe.dev/)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3387180.svg)](https://doi.org/10.5281/zenodo.3387180)

# kwb.pkgbuild

Helper functions for automating R package development at KWB
to a predefined style.

## Installation

For details on how to install KWB-R packages checkout our [installation tutorial](https://kwb-r.github.io/kwb.pkgbuild/articles/install.html).

```r
### Optionally: specify GitHub Personal Access Token (GITHUB_PAT)
### See here why this might be important for you:
### https://kwb-r.github.io/kwb.pkgbuild/articles/install.html#set-your-github_pat

# Sys.setenv(GITHUB_PAT = "mysecret_access_token")

# Install package "remotes" from CRAN
if (! require("remotes")) {
  install.packages("remotes", repos = "https://cloud.r-project.org")
}

# Install KWB package 'kwb.pkgbuild' from GitHub
remotes::install_github("KWB-R/kwb.pkgbuild")
```

## Documentation

Release: [https://kwb-r.github.io/kwb.pkgbuild](https://kwb-r.github.io/kwb.pkgbuild)

Development: [https://kwb-r.github.io/kwb.pkgbuild/dev](https://kwb-r.github.io/kwb.pkgbuild/dev)
