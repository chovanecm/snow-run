#!/bin/bash

# Execute file as a background script

my_dir=$(dirname $0)
source $my_dir/../include/env.sh

ensure_instance_set

SCRIPT_FILE=$1
# get security token
token=$(curl https://$snow_instance/sys.scripts.do -b $SNOW_COOKIE_FILE --cookie-jar $SNOW_COOKIE_FILE -sS | extract_sysparm_ck)
if [[ -z $token ]]
then
   echo "Cannot get security token for service-now instance $snow_instance" >&2
   echo "Try logging in again (snow login)" >&2
   exit 1
fi;

function split_std_and_error {
   DONE=false
   WRITE_TO=
   
   until $DONE
   do
      read str || DONE=true
      if [[ "$str" == 'SNOW_STD_OUT:' ]]
      then
         WRITE_TO=stdout
      elif [[ "$str" == 'SNOW_ERR_OUT:' ]]
      then
         WRITE_TO=stderr
      elif [[ $DONE == false ]]
      then
         if [[ $WRITE_TO == "stdout" ]]
         then
            echo "$str" | decode_html
         elif [[ $WRITE_TO == "stderr" ]]
         then
            echo "$str" | decode_html >&2
         fi
      fi
   done
}

function mark_script_output () {
   # Try to remove characters from the output and mark what is standard and what is error
   sed 's/.*<PRE>\*\*\* Script: /\nSNOW_STD_OUT:\n/; s/.*<PRE>/SNOW_ERR_OUT:\n/; s/\(<BR\/>\)\{0,1\}\*\*\* Script: /\nSNOW_STD_OUT:\n/g; s/<BR\/>/\nSNOW_ERR_OUT:\n/g'
}

curl https://$snow_instance/sys.scripts.do -H 'Connection: keep-alive' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' -sS -b $SNOW_COOKIE_FILE --data "sysparm_ck=$token&runscript=Run+script&record_for_rollback=on&quota_managed_transaction=on" --data-urlencode script@$SCRIPT_FILE --compressed \
 | tee $SNOW_TMP_DIR/last_run_output.txt \
 | mark_script_output \
 | tee $SNOW_TMP_DIR/last_parsed_output.txt \
 | head -n -1 | split_std_and_error
# exit with the first command's (curl)  exit code
exit ${PIPESTATUS[0]}