#!/usr/bin/env bash


###############################################################################
#
#	Purpose:
#	    Clean up Containers
#
#   Usage:
#       ./docker.sh clean
#
if [[ "$1" == "clean" ]]; then
    docker ps -a && docker kill $(docker ps -q) && docker rm $(docker ps -a -q)
    docker system prune
fi
###############################################################################