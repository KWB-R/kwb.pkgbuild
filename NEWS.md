# kwb.pkgbuild 0.1.0.9000

* improved use in case of an existing R package (by reading information from 
DESCRIPTION file with function `kwb.pkgbuild::read_description`)

* improved documentation generation (closes #6)

   +  changed `README.Rmd` to `index.Rmd` (used by `pkgdown::build_home`) and added 
      "Installation" chapter 

   + added "Installation" chapter in `README.md` for Github repo site

* automatically convert package title to Title Case with `tools::toTitleCase()` 

* added a `NEWS.md` file to track changes to the package.

* see http://style.tidyverse.org/news.html for writing a good `NEWS.md`


