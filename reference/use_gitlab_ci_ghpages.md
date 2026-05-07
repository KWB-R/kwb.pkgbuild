# Adds .gitlab-ci.yml (which should be saved in root dir of "gh-pages" branch)

Adds .gitlab-ci.yml (which should be saved in root dir of "gh-pages"
branch)

## Usage

``` r
use_gitlab_ci_ghpages(
  dest_dir = getwd(),
  yml_vector = gitlab_ci_template_ghpages()
)
```

## Arguments

- dest_dir:

  directory to write (default: getwd())

- yml_vector:

  a yml imported as string vector (default:
  gitlab_ci_template_ghpages())

## Value

writes .gitlab-ci.yml
