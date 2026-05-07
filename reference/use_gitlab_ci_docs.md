# Adds .gitlab-ci.yml (if repo contains a "docs" subfolder)

Adds .gitlab-ci.yml (if repo contains a "docs" subfolder)

## Usage

``` r
use_gitlab_ci_docs(dest_dir = getwd(), yml_vector = gitlab_ci_template_docs())
```

## Arguments

- dest_dir:

  directory to write (default: getwd())

- yml_vector:

  a yml imported as string vector (default: gitlab_ci_template_docs())

## Value

writes .gitlab-ci.yml and adds it .Rbuildignore
