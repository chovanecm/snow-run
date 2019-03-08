#!/bin/bash
my_dir=$(dirname $0)
source $my_dir/../include/env.sh

ensure_instance_set

SCRIPT_FILE=$1
token=$(curl https://$snow_instance/sys.scripts.do -b $SNOW_COOKIE_FILE --cookie-jar $SNOW_COOKIE_FILE -s | $SNOW_INCLUDE_DIR/_grep-sysparm_ck.sh)
if [[ -z $token ]]
then
   echo "Cannot get security token for service-now instance $snow_instance" >&2
   exit
fi;

curl https://$snow_instance/sys.scripts.do -H 'Connection: keep-alive' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' -s -b $SNOW_COOKIE_FILE --data "sysparm_ck=$token&runscript=Run+script&record_for_rollback=on&quota_managed_transaction=on" --data-urlencode script@$SCRIPT_FILE --compressed | tee $SNOW_TMP_DIR/last_run_output.txt | sed 's/.*<PRE>//' | sed 's/<BR\/>/\n/g' | sed 's/\*\*\* Script: //g' | grep -v  "</PRE><HR/></BODY></HTML>" \
 | sed 's/&quot;/"/g'
