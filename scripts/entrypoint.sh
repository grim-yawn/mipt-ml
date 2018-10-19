#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

export KAGGLE_USERNAME=${KAGGLE_USERNAME:?"KAGGLE_USERNAME must be set"}
export KAGGLE_KEY=${KAGGLE_KEY:?"KAGGLE_KEY must be set"}

# Load competitions data
kaggle competitions download -c titanic -p datasets/titanic

exec "$@"
