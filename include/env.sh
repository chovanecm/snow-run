#!/bin/bash
export SNOW_DIR=~/.snow-run
export SNOW_TMP_DIR=$SNOW_DIR/tmp/$snow_instance
export SNOW_COOKIE_FILE=$SNOW_TMP_DIR/cookies.txt
mkdir -p $SNOW_TMP_DIR

export SNOW_INCLUDE_DIR=$(dirname ${BASH_SOURCE})

function ensure_instance_set() {
    if [[ -z ${snow_instance} ]];
    then
        echo Set snow_instance ENV variable to something like dev123.service-now.com first! >&2
        exit 1
    fi
}
