# Copy files from Vignettes Dir to Deploy idir

Copy files from Vignettes Dir to Deploy idir

## Usage

``` r
copy_files_from_vignettes_dir_to_deploy_dir(
  source_dir = ".",
  deploy_dir = "docs",
  pattern = "\\.json$",
  overwrite = TRUE
)
```

## Arguments

- source_dir:

  default: "."

- deploy_dir:

  default: "docs

- pattern:

  file pattern to export (default: "\\json\$")

- overwrite:

  should existing files be overwritten (default: TRUE)

## Value

files matching pattern copied to deploy_dir
