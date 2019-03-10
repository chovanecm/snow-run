#!/bin/bash
my_dir=$(dirname $0)
source $my_dir/../include/env.sh

ensure_instance_set


export login_token=$($SNOW_INCLUDE_DIR/_get-sysparm_ck.sh)

if [[ -z $login_token ]]
then
  echo "Could not obtain login token to access service-now instance $snow_instance" >&2
  exit 1
fi;

curl https://${snow_instance}/login.do -b $SNOW_COOKIE_FILE --data "sysparm_ck=$login_token&user_name=$snow_user&user_password=$snow_pwd&ni.nolog.user_password=true&ni.noecho.user_name=true&ni.noecho.user_password=true&screensize=1920x1080&sys_action=sysverb_login" --compressed --cookie-jar $SNOW_COOKIE_FILE 

status=$?
if [[ $status -ne 0 ]];
then
    echo "SNOW Login not successful. curl returned $status" >&2
fi
