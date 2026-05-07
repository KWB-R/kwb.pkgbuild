# Use Package Skeleton

Use Package Skeleton

## Usage

``` r
use_pkg_skeleton(pkg_name)
```

## Arguments

- pkg_name:

  name of R package

## Value

creates pkg skeleton in current working directory

## Examples

``` r
## valid pkg folder
pkg_name <- "pkgname"
pkg_dir <- file.path(tempdir(), pkg_name)
pkg_dir <- create_pkg_dir(pkg_dir)
#> /tmp/RtmpoO8fCx/pkgname is a valid 'root_dir' for pkg 'pkgname'
#> Warning: /tmp/RtmpoO8fCx/pkgname was not created as it already existed.
withr::with_dir(pkg_dir, {use_pkg_skeleton(pkg_name)})
#> ✔ Setting active project to "/tmp/RtmpoO8fCx/pkgname".
#> ✔ Writing pkgname.Rproj.
#> ✔ Adding ".Rproj.user" to .gitignore.
#> NULL
```
