# Create KWB-styled "NEWS.md"

Create KWB-styled "NEWS.md"

## Usage

``` r
use_news_md(
  news_txt = "* Added a `NEWS.md` file to track changes to the package.",
  style_guide_url = "https://style.tidyverse.org/news.html"
)
```

## Arguments

- news_txt:

  text added to news (default: "\* Added a 'NEWS.md' file to track
  changes to the package.")

- style_guide_url:

  refer to tidyverse style website documenting how to write a good
  "NEWS.md"(default: "https://style.tidyverse.org/news.html")

## Value

writes "NEWS.md" (in case it is not existing)
