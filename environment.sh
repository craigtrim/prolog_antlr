#!/usr/bin/env bash

# bash/zhs compatible
THIS_SCRIPT=${BASH_SOURCE[0]:-${(%):-%x}}
export PROJECT_BASE="$(cd "$(dirname "${THIS_SCRIPT}")" && pwd)"

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

# Expand the variable named by $1 into its value. Works in both {ba,z}sh
# eg: a=HOME $(var_expand $a) == /home/me
# https://unix.stackexchange.com/a/472069/91054
var_expand() {
  if [ -z "${1-}" ] || [ $# -ne 1 ]; then
    printf 'var_expand: expected one argument\n' >&2;
    return 1;
  fi
  eval printf '%s' "\"\${$1?}\""
}

# Generate a .env file with the vars that be have set here.
# VS Code takes advantage of this file
echo "# Automatically generated" >"${PROJECT_BASE}"/.env
grep '^export' <"${THIS_SCRIPT}" | cut -d " " -f 2 | cut -d "=" -f 1 | sort | while read -r line; do
  echo "${line}"=\"$(var_expand $line)\" >>"${PROJECT_BASE}"/.env
done

# Get our project folders in the pythonpath
while read -r pkg; do

  [[ -z "$pkg" ]] && continue
  [[ ${pkg:0:1} == '#' ]] && continue

  if ! echo "${PYTHONPATH}" | grep -Eq "$pkg"; then
    PYTHONPATH="${PYTHONPATH:+${PYTHONPATH}:}$PROJECT_BASE$pkg"
  fi

done <"${PROJECT_BASE}"/packages.txt

echo $PYTHONPATH
export PYTHONPATH
