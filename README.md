## MIPT-ML
[![CircleCI](https://circleci.com/gh/WeitBelou/mipt-ml/tree/master.svg?style=svg)](https://circleci.com/gh/WeitBelou/mipt-ml/tree/master)
[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/weitbelou/mipt-ml/master)

### Requirements
1) `make`
2) `docker` installed and in `PATH`. Permissions to run `docker` w/o `sudo`.

### Usage

#### Run jupyter notebook server
```bash
make run
```

#### To convert notebooks to HTML:
```bash
make html
```
HTML files will be written to dist directory