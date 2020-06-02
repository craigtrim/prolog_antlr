#!/usr/bin/env bash

# bash/zhs compatible
THIS_SCRIPT=${BASH_SOURCE[0]:-${(%):-%x}}
export PROJECT_BASE="$(cd "$(dirname "${THIS_SCRIPT}")" && pwd)"

# Have a shared file where we keep cloud credentials
TEAM_SECRETS=${PROJECT_BASE}/environment.team.sh
test -f "${TEAM_SECRETS}" && source ${TEAM_SECRETS}

# Allow developers to tweak their environment
PERSONAL_OVERRIDES=${PROJECT_BASE}/environment.local.sh
test -f "${PERSONAL_OVERRIDES}" && source ${PERSONAL_OVERRIDES}

# Make sure virtualenv is activated
SITE_PACKAGES="$(python -c 'import site; print(site.getsitepackages()[0])')"
if [[ ${SITE_PACKAGES} == *"antlr"* ]]; then
  echo ""
else
  echo "ERROR: You need to use the antlr virtualenv"
  echo "  You can create it with:"
  echo "    conda env create -f=environment.yml"
  echo "  You can activate it with:"
  echo "    conda activate antlr"
  return
fi

# Get our project folders in the pythonpath
while read -r pkg; do

  [[ -z "$pkg" ]] && continue
  [[ ${pkg:0:1} == '#' ]] && continue

  if ! echo "${PYTHONPATH}" | grep -Eq "$pkg"; then
    PYTHONPATH="${PYTHONPATH:+${PYTHONPATH}:}$GTS_BASE$pkg"
  fi

done <"${PROJECT_BASE}"/packages.txt
export PYTHONPATH
