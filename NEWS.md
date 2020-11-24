# [kwb.pkgbuild 0.1.6](https://github.com/KWB-R/kwb.pkgbuild/releases/tag/v0.1.6) <small>2020-11-24</small>

* Add function `deploy_to_branch_with_extra_files()` for using github-actions to 
deploy to gh-pages (#73) 

* Use GitHub Actions as default CI (#78) and removed support for Travis and Appveyor

# [kwb.pkgbuild 0.1.5](https://github.com/KWB-R/kwb.pkgbuild/releases/tag/v0.1.5) <small>2020-10-09</small>

* Update default GitHub branch to `main` since 2020-10-01 (see: [Article](https://www.zdnet.com/article/github-to-replace-master-with-main-starting-next-month/))

* `add_creation_metadata`: write creation metadata in yaml format as default 

* travis.yml template: add dependencies required for pkgdown (>= 1.6.1) installation

* Update Travis-CI badges after migrating KWB-R build from travis-ci.org to .com (#72) 

# [kwb.pkgbuild 0.1.4](https://github.com/KWB-R/kwb.pkgbuild/releases/tag/v0.1.4) <small>2020-06-23</small>

* Fix use_travis_deploy() to correctly generate key for using pkgdown on Travis to deploy to gh-pages (#70) 

# [kwb.pkgbuild 0.1.3](https://github.com/KWB-R/kwb.pkgbuild/releases/tag/v0.1.3) <small>2020-05-04</small>

* Add functions missing in pkgdown (>= 1.5.0) required for *deploy_site_github_with_extra_files()*

# [kwb.pkgbuild 0.1.2](https://github.com/KWB-R/kwb.pkgbuild/releases/tag/v0.1.2) <small>2019-09-17</small>

* Fixed MIT LICENSE creation for CRAN (#60)

# [kwb.pkgbuild 0.1.1](https://github.com/KWB-R/kwb.pkgbuild/releases/tag/v0.1.1) <small>2019-09-06</small>

* Use .md instead of .Rmd due to changed workflow in pkgdown v1.4 (see: [r-lib/pkgdown#1136](https://github.com/r-lib/pkgdown/issues/1136))

# [kwb.pkgbuild 0.1.0](https://github.com/KWB-R/kwb.pkgbuild/releases/tag/v0.1.0) <small>2019-09-04</small>

* Improved use in case of an existing R package (by reading information from 
DESCRIPTION file with function `kwb.pkgbuild::read_description`)

* Improved documentation generation (closes #6)

   +  Changed `README.Rmd` to `index.Rmd` (used by `pkgdown::build_home`) and added 
      "Installation" chapter 

   + Added "Installation" chapter in `README.md` for Github repo site

* Automatically convert package title to Title Case with `tools::toTitleCase()` 

* Added a `NEWS.md` file to track changes to the package.

* See http://style.tidyverse.org/news.html for writing a good `NEWS.md`


