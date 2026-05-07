# Adds .gitlab-ci.yml (if repo contains on root in a "gh-pages" branch)

Adds .gitlab-ci.yml (if repo contains on root in a "gh-pages" branch)

## Usage

``` r
use_gitlab_ci_blogdown(
  dest_dir = getwd(),
  yml_vector = gitlab_ci_template_blogdown()
)
```

## Arguments

- dest_dir:

  directory to write (default: getwd())

- yml_vector:

  a yml imported as string vector (default:
  gitlab_ci_template_blogdown())

## Value

writes .gitlab-ci.yml
