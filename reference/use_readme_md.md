# Create KWB-styled `README.md`

Generates a `README.md` with the KWB default badge set, the package
description from `DESCRIPTION`, an installation snippet and links to the
release and development documentation websites.

## Usage

``` r
use_readme_md(user = "KWB-R", domain = "github", stage = "experimental")
```

## Arguments

- user:

  user name or organisation under which the repository is hosted
  (default: "KWB-R")

- domain:

  under which the repository is hosted (default: "github")

- stage:

  badge declaring the developmental stage of the package according to
  <https://www.tidyverse.org/lifecycle/>; valid values are
  "experimental", "maturing", "stable", "retired", "archived",
  "dormant", "questioning" (default: "experimental")

## Value

writes `README.md` and adds it to `.Rbuildignore`
