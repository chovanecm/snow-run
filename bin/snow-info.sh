#!/bin/bash
my_dir=$(dirname $0)
source $my_dir/../include/env.sh

ensure_instance_set

echo SNOW RUN against $snow_instance instance.
echo Temp directory: $SNOW_TMP_DIR
echo Protect that directory from being read by others.