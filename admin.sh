#!/usr/bin/env bash

#  \\wsl$\Ubuntu\home\craig\git\prolog_antlr\workspace\plscripts\plscripts

export PROJECT_BASE="/home/craig/git/prolog_antlr"
export SCRIPTS_HOME="${PROJECT_BASE}/workspace/plscripts/plscripts"
export PROLOG_INDIR="${PROJECT_BASE}/resources/input/prolog"

python ${SCRIPTS_HOME}/parse_prolog_file.py ${PROLOG_INDIR}/"$1"
