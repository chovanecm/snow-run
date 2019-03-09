#!/bin/bash
export SNOW_DIR=~/.snow-run
export SNOW_TMP_DIR=$SNOW_DIR/tmp/$snow_instance
export SNOW_COOKIE_FILE=$SNOW_TMP_DIR/cookies.txt
mkdir -p $SNOW_TMP_DIR

export SNOW_INCLUDE_DIR=$(dirname ${BASH_SOURCE})
export SNOW_BIN_DIR=$SNOW_INCLUDE_DIR/../bin
export SNOW_JS_DIR=$SNOW_INCLUDE_DIR/../js
export SNOW_JS_SYS_PREFIX=sys
export SNOW_JS_SYS_DIR=$SNOW_JS_DIR/$SNOW_JS_SYS_PREFIX
