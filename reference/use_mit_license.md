# Create MIT licence with KWB style

Create MIT licence with KWB style

## Usage

``` r
use_mit_license(
  copyright_holder = list(name = kwb_string(), start_year = NULL)
)
```

## Arguments

- copyright_holder:

  list with name of copyright holder and additional start_year (e.g.
  "2017") of copyright protection. If not specified (start_year = NULL),
  the current year is used as year only! (default: "list(name =
  kwb.pkgbuild:::kwb_string(), start_year = NULL)")

## Value

creates MIT licence file
