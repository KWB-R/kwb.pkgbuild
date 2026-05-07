# Adds .gitlab-ci.yml

Adds .gitlab-ci.yml

## Usage

``` r
use_gitlab_ci_pkgdown(
  dest_dir = getwd(),
  yml_vector = gitlab_ci_template_pkgdown()
)
```

## Arguments

- dest_dir:

  directory to write (default: getwd())

- yml_vector:

  a yml imported as string vector (default:
  gitlab_ci_template_pkgdown(), where "\<owner\>/\<repo\>" is replaced
  with value from DESCRIPTION specified in field URL, e.g.
  https://github.com/KWB-R/kwb.pkgbuild" sets "KWB-R/kwb.pkgbuild" as
  "\<owner\>/\<repo\>")

## Value

writes .gitlab-ci.yml
