# Wrapper function for preparing R package with KWB styling

Wrapper function for preparing R package with KWB styling

## Usage

``` r
use_pkg(
  author = kwb_author("rustler"),
  pkg = kwb_package("kwb.umberto"),
  version = "0.0.0.9000",
  license = "MIT + file LICENSE",
  copyright_holder = list(name = kwb_string(), start_year = NULL),
  funder = NULL,
  user = "KWB-R",
  domain = "github",
  stage = "experimental",
  auto_build_pkgdown = FALSE,
  claude = FALSE,
  dbg = TRUE,
  ...
)
```

## Arguments

- author:

  author information in list format (default:
  kwb.pkgbuild:::kwb_author("rustler"))

- pkg:

  package description in list format (default:
  kwb.pkgbuild:::kwb_package("kwb.umberto"))

- version:

  user defined version number (e.g. 0.1.0) or default "0.0.0.9000"
  version number for initial development version (default: "0.0.0.9000")

- license:

  license (default: "MIT + file LICENSE")

- copyright_holder:

  list with name of copyright holder and additional start_year (e.g.
  "2017") of copyright protection. If not specified (start_year = NULL),
  the current year is used as year only! (default: "list(name =
  kwb.pkgbuild:::kwb_string(), start_year = NULL)")

- funder:

  funder/funding agency of R package (default: NULL), e.g. project name
  (e.g. AQUANES)

- user:

  user name or organisation under which repository defined in parameter
  "repo" is hosted (default: "KWB-R")

- domain:

  under which repository is hosted (default: "github")

- stage:

  badge declares the developmental stage of a package, according to
  \[https://www.tidyverse.org/lifecycle/\](https://www.tidyverse.org/lifecycle/),
  valid arguments are: "experimental", "maturing", "stable", "retired",
  "archived", "dormant", "questioning"), (default: "experiment")

- auto_build_pkgdown:

  prepare Travis for pkgdown::build_site() (default: FALSE), only
  possible if GITHUB repo already existing

- claude:

  if TRUE, additionally adds the Claude Code GitHub Actions workflows
  (claude.yaml, claude-code-review.yaml). Requires the repository secret
  CLAUDE_CODE_OAUTH_TOKEN to be configured in GitHub. (default: FALSE)

- dbg:

  print debug messages (default: TRUE)

- ...:

  additional arguments passed to use_autopkgdown() (only relevant if
  "auto_build_pkgdown" == TRUE)

## Value

writes DESCRIPTION file using usethis::use_description() with KWB style
