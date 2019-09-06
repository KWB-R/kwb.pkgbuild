* current development version

# [kwb.pkgbuild 0.1.1](https://github.com/KWB-R/kwb.pkgbuild/releases/tag/v0.1.0) <small>2019-09-06</small>

* use .md instead of .Rmd due to changed workflow in pkgdown v1.4 (see: [r-lib/pkgdown#1136](https://github.com/r-lib/pkgdown/issues/1136))

# [kwb.pkgbuild 0.1.0](https://github.com/KWB-R/kwb.pkgbuild/releases/tag/v0.1.0) <small>2019-09-04</small>

* improved use in case of an existing R package (by reading information from 
DESCRIPTION file with function `kwb.pkgbuild::read_description`)

* improved documentation generation (closes #6)

   +  changed `README.Rmd` to `index.Rmd` (used by `pkgdown::build_home`) and added 
      "Installation" chapter 

   + added "Installation" chapter in `README.md` for Github repo site

* automatically convert package title to Title Case with `tools::toTitleCase()` 

* added a `NEWS.md` file to track changes to the package.

* see http://style.tidyverse.org/news.html for writing a good `NEWS.md`


