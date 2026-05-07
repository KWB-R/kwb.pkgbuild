# Create KWB-styled `index.md`

Generates an `index.md` (used by
[`pkgdown::build_home()`](https://pkgdown.r-lib.org/reference/build_home.html))
with the KWB default badge set (GitHub Actions, codecov, lifecycle,
CRAN, R-universe), the package description from `DESCRIPTION` and an
installation snippet.

## Usage

``` r
use_index_md(user = "KWB-R", domain = "github", stage = "experimental")
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

writes `index.md` (used as `pkgdown` home) and adds the pattern to
`.Rbuildignore`. Invisibly returns the character vector that was
written.
