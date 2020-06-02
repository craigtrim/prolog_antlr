#!/usr/bin/env bash

cd /code

#conda env create -f=requirements.conda.yml
source activate gtstext
source environment.sh
redis-server --daemonize yes
#./devops/install-ibm-db2.sh
export SUPPLY_SRC_BUILD="supply_src_20190801"
export SUPPLY_TAG_BUILD="supply_tag_20190801"
export PARSE_API="${GTS_BASE}/workspace/gtsdataingest/gtsdataingest/core/bp/parse_api.py"
python ${PARSE_API} "parse-manifest" "Supply" 40401 45450 false
#./admin.sh chunk parse 0 50