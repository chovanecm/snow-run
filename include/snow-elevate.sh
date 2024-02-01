#!/bin/bash
my_dir=$(dirname $0)
source $my_dir/../include/env.sh

ensure_instance_set


token=$(curl ${CURL_OPTIONS} -L -b $SNOW_COOKIE_FILE https://$snow_instance/navpage.do -sS | grep -oP "g_ck = '\K\w+")
if [[ -z $token ]]
then
   echo "Could not obtain authentication token to elevate privileges." >&2
   exit
fi;

curl ${CURL_OPTIONS} "https://$snow_instance/api/now/ui/impersonate/role" -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.9' -H 'X-WantSessionNotificationMessages: true' -H "X-UserToken: $token" -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept: application/json, text/plain, */*' -H 'Connection: keep-alive' --data-binary '{"roles":"security_admin"}' -b $SNOW_COOKIE_FILE --cookie-jar $SNOW_COOKIE_FILE --compressed -sS
exit $?
