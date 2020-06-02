#!/usr/bin/env bash

cd /code

source /opt/conda/etc/profile.d/conda.sh
conda activate gtstext
source environment.sh

# Execute the travis tests: run any line
LANGUAGE_VARIABILITY_RED_THRESHOLD=80
grep py.test .travis.yml | sed "s/^[^\-]*-//" | sed "s/-n auto/-n4/" | while read line; do
    set -o noglob
    echo "$line"
    eval "$line"
    if [ $? -ne 0 ]; then
        echo "tests failed"
        exit 1
    fi
done
