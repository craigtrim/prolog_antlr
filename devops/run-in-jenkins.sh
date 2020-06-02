#!/usr/bin/env bash

echo "starting run in Jenkins script"
apt-get update && \
	apt-get install -y  \
	libpq-dev build-essential checkinstall apt-utils && \
	rm -rf /var/lib/apt/lists/*

conda update -n base -c defaults conda -y
conda install -c anaconda redis -y
conda env create -f environment.yml
source activate gtstext
source environment.sh
redis-server --daemonize yes
setup/spacy.sh

source admin.sh regression all
