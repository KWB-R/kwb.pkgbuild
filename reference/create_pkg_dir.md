# Create Package Directory

Create Package Directory

## Usage

``` r
create_pkg_dir(pkg_dir)
```

## Arguments

- pkg_dir:

  path to package directory to be created, including the pkgname as last
  folder

## Value

creates directory for package if not existing

## Examples

``` r
## not a valid pkg folder
if (FALSE) { # \dontrun{
pkg_dir <- file.path(tempdir(), "pkgname/pkgname")
create_pkg_dir(pkg_dir)
} # }
## valid pkg folder
pkg_dir <- file.path(tempdir(), "pkgname")
create_pkg_dir(pkg_dir)
#> /tmp/RtmpoO8fCx/pkgname is a valid 'root_dir' for pkg 'pkgname'
#> [1] "/tmp/RtmpoO8fCx/pkgname"
```
