# [kwb.pkgbuild 0.3.0](https://github.com/KWB-R/kwb.pkgbuild/releases/tag/v0.3.0) <small>2026-05-07</small>

* Modernise GitHub Actions workflows (both in `.github/workflows/` of this
  repo and the templates in `inst/templates/ci_github-actions/`) so that
  they run on current GitHub-hosted runners again:

  - Bump action versions: `actions/checkout@v4`, `actions/upload-artifact@v4`,
    `codecov/codecov-action@v4`, and replace the deprecated `r-lib/actions@master`
    references with `r-lib/actions@v2`.

  - Switch from the retired `ubuntu-20.04` runner to `ubuntu-latest` and
    rename the matrix entry `oldrel` to `oldrel-1`.

  - Replace the archived `r-hub/sysreqs` step with
    `r-lib/actions/setup-r-dependencies@v2`, which also handles dependency
    caching out of the box.

  - Fix a stale `if: runner.os == 'Linux (no, try without!)'` condition that
    silently disabled the Linux system-dependency step.

  - `pkgdown` workflow: deploy via `JamesIves/github-pages-deploy-action@v4`
    on `ubuntu-latest`, with explicit `permissions: contents: write` and a
    concurrency group.

  - `test-coverage` workflow: produce a Cobertura report and upload via the
    new `codecov/codecov-action@v4`; upload test artefacts on failure.

  - `pr-commands` workflow: gate `/document` and `/style` jobs on
    `github.event.issue.pull_request` so they no longer fire on plain issue
    comments.

* Add optional Claude Code GitHub Actions workflows (analogue to
  [kwb.raindrop](https://github.com/KWB-R/kwb.raindrop/tree/main/.github/workflows)):

  - New templates in `inst/templates/ci_github-actions-claude/`:
    `claude.yaml` (responds to `@claude` mentions in issues and PR reviews)
    and `claude-code-review.yaml` (automatic PR review on `opened` /
    `synchronize`).

  - New exported function `use_ghactions_claude()` to add only the Claude
    workflows to an existing package.

  - `use_ghactions()` and `use_pkg()` gain a `claude = FALSE` toggle that
    additionally installs the Claude workflows when set to `TRUE`. The
    workflows expect a `CLAUDE_CODE_OAUTH_TOKEN` repository secret to be
    configured in GitHub.

# [kwb.pkgbuild 0.2.3](https://github.com/KWB-R/kwb.pkgbuild/releases/tag/v0.2.3) <small>2022-10-24</small>

* Fix GitHub action worfklows: 

  - fix continuous integration workflows (i.e. `pkgdown`, `Rcmdcheck`, 
  `test-coverage`)), which were broken after 2022-10-15 due to unavailable `master` 
  branch in upstream dependency [r-lib/actions](https://github.com/r-lib/actions).

  - fix [pkgdown](https://github.com/r-lib/pkgdown) GitHub actions workflow, which 
  crashed during `build_news()` generation on `windows` due to an `recent change in Windows that has made it incompatible   with old openssl servers` (thanks to [@jeroen](https://github.com/KWB-R/kwb.geosalz/commit/925944151617d9b3b7f50008fafd29eb18ba1d65#commitcomment-87352971) for that hint!) and [@garborcsardi](https://github.com/r-lib/pkgdown/issues/2211#issuecomment-1281171018) 
  for this workaround!). For full discussion on this issue (which might be 
  fixed in an upcoming [pkgdown](https://github.com/r-lib/pkgdown) version 2.0.7)
  see [pkgdown#2211](https://github.com/r-lib/pkgdown/issues/2211)

# [kwb.pkgbuild 0.2.2](https://github.com/KWB-R/kwb.pkgbuild/releases/tag/v0.2.2) <small>2022-05-11</small>

* GitHub actions: use `windows` as default operating system for `pkgdown` (for 
building documentation website) and `test coverage` workflow instead of `macosx`

# [kwb.pkgbuild 0.2.1](https://github.com/KWB-R/kwb.pkgbuild/releases/tag/v0.2.1) <small>2022-02-09</small>

* Bugfix for correctly writing package documentation website URL to `_pkgdown.yml`

# [kwb.pkgbuild 0.2.0](https://github.com/KWB-R/kwb.pkgbuild/releases/tag/v0.2.0) <small>2022-01-20</small>

* Documentation website with `pkgdown (>= 2.0.2)` and new [KWB website](https://kompetenz-wasser.de):   
  
  - Design: now using `bootstrap5` and colors slightly adapted to KWB design. 
  
  - URL to KWB logo was updated due to new website. 
  
  - **Attention: URLs to projects (including logos) need to be corrected manually (for old `_pkgdown.yml` files**

* Deleted functions for unused CIs `travis` and `appveyor`


# [kwb.pkgbuild 0.1.9](https://github.com/KWB-R/kwb.pkgbuild/releases/tag/v0.1.9) <small>2021-09-10</small>

* Fix `Rcmdcheck` workflow on GitHub Actions by explicitly adding default organisation `GITHUB_PAT`


# [kwb.pkgbuild 0.1.8](https://github.com/KWB-R/kwb.pkgbuild/releases/tag/v0.1.8) <small>2021-07-13</small>

* Add `use_badge_runiverse()` (for linking to [https://kwb-r.r-universe.dev](https://kwb-r.r-universe.dev))
if package is available and use for `index.md` and `README.md`

# [kwb.pkgbuild 0.1.7](https://github.com/KWB-R/kwb.pkgbuild/releases/tag/v0.1.7) <small>2021-02-23</small>

* Improve re-usability of Github Actions badges  (for R package `kwb.pkgstatus`)

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


