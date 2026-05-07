# deploy_site_github_with_extra_files

for details see pkgdown::deploy_site_github(), only parameter
vignettes_file_pattern_to_copy added

## Usage

``` r
deploy_site_github_with_extra_files(
  pkg = ".",
  vignettes_file_pattern_to_copy = "\\.json$",
  install = TRUE,
  tarball = Sys.getenv("PKG_TARBALL", ""),
  ssh_id = Sys.getenv("id_rsa", ""),
  commit_message = construct_commit_message(pkg),
  clean = FALSE,
  verbose = TRUE,
  host = "github.com",
  repo_slug = Sys.getenv("TRAVIS_REPO_SLUG", ""),
  ...
)
```

## Arguments

- pkg:

  "."

- vignettes_file_pattern_to_copy:

  file patern for copying files from vignettes directory into deploy
  directory (default: "\\json\$")

- install:

  Optionally, opt-out of automatic installation. This is necessary if
  the package you're documenting is a dependency of pkgdown

- tarball:

  tarball Sys.getenv("PKG_TARBALL", "")

- ssh_id:

  ssh_id Sys.getenv("id_rsa", "")

- commit_message:

  commit_message (default: construct_commit_message(pkg))

- clean:

  Clean all files from old site (default: FALSE)

- verbose:

  Print verbose output (default: TRUE)

- host:

  The GitHub host url (default: "github.com")

- repo_slug:

  The \`user/repo\` slug for the repository.

- ...:

  additional arguments passed to \[deploy_to_branch_with_extra_files\]

## Value

deploy pkgdown site including additional files in "vignettes" source
folder to "gh-pages"
