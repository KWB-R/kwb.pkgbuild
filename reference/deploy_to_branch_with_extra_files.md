# Build and deploy a site locally with extra files

Assumes that you're in a git clone of the project, and the package is
already installed.

## Usage

``` r
deploy_to_branch_with_extra_files(
  pkg = ".",
  vignettes_file_pattern_to_copy = "\\.json",
  commit_message = construct_commit_message(pkg),
  clean = FALSE,
  branch = "gh-pages",
  remote = "origin",
  github_pages = (branch == "gh-pages"),
  ...
)
```

## Arguments

- pkg:

  "."

- vignettes_file_pattern_to_copy:

  file patern for copying files from vignettes directory into deploy
  directory (default: "\\json\$")

- commit_message:

  commit_message (default: construct_commit_message(pkg))

- clean:

  Clean all files from old site (default: FALSE)

- branch:

  The git branch to deploy to

- remote:

  The git remote to deploy to

- github_pages:

  Is this a GitHub pages deploy. If \`TRUE\`, adds a \`CNAME\` file for
  custom domain name support, and a \`.nojekyll\` file to suppress
  jekyll rendering.

- ...:

  Additional arguments passed to pkgdown::build_site()
