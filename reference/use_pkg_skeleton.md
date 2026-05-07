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
#> /tmp/RtmpZl6kC1/pkgname is a valid 'root_dir' for pkg 'pkgname'
#> Warning: /tmp/RtmpZl6kC1/pkgname was not created as it already existed.
withr::with_dir(pkg_dir, {use_pkg_skeleton(pkg_name)})
#> ✔ Setting active project to "/tmp/RtmpZl6kC1/pkgname".
#> ✔ Writing pkgname.Rproj.
#> ✔ Adding ".Rproj.user" to .gitignore.
#> NULL
```
