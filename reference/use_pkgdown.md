# Set up `pkgdown` with KWB styling

Calls
[`usethis::use_pkgdown()`](https://usethis.r-lib.org/reference/use_pkgdown.html)
and additionally writes a `_pkgdown.yml` configured with KWB defaults
(Bootstrap 5 + cerulean theme, KWB authors block, copyright holder
logo).

## Usage

``` r
use_pkgdown(
  author = kwb_author("rustler"),
  copyright_holder_name = kwb_string(),
  pkg = get_pkgname(),
  user = "kwb-r",
  domain = "github",
  kwb_logo_url = "https://logos.kompetenz-wasser.io/KWB_Logo_M_Blau_RGB.svg",
  kwb_logo_href = "https://www.kompetenz-wasser.de"
)
```

## Arguments

- author:

  list of author attributes (default:
  kwb.pkgbuild:::kwb_author("rustler"))

- copyright_holder_name:

  name of copyright holder (default: kwb.pkgbuild:::kwb_string())

- pkg:

  name of KWB package (default: get_pkgname())

- user:

  name of GitHub user/organisation (default: 'kwb-r')

- domain:

  name of domain for webpage publishing (default: 'github')

- kwb_logo_url:

  URL of the KWB logo image embedded in the copyright holder's `pkgdown`
  author block (default:
  `"https://logos.kompetenz-wasser.io/KWB_Logo_M_Blau_RGB.svg"`)

- kwb_logo_href:

  URL the KWB logo links to (default:
  `"https://www.kompetenz-wasser.de"`)

## Value

invisibly; as a side effect writes `_pkgdown.yml` with KWB styling and
adds it to `.Rbuildignore`.
