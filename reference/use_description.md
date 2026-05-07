# Use DESCRIPTION with KWB styling

Use DESCRIPTION with KWB styling

## Usage

``` r
use_description(
  author = kwb_author("rustler"),
  pkg = kwb_package("kwb.umberto"),
  version = NULL,
  license = "MIT + file LICENSE",
  copyright_holder_name = kwb_string(),
  funder = NULL
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

  user defined version number (e.g. 0.1.0) or default version number
  0.0.0.9000 in case (version = NULL) of first release

- license:

  license (default: "MIT + file LICENSE")

- copyright_holder_name:

  name of copyright holder (default: kwb.pkgbuild:::kwb_string())

- funder:

  funder/funding agency of R package (default: NULL), e.g. project name
  (e.g. AQUANES)

## Value

writes DESCRIPTION file using usethis::use_description() with KWB style
