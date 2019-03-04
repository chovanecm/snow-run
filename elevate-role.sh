token=$(curl -b cookies.txt https://servicenow-dev.dhl.com/navpage.do -s | grep -oP "g_ck = '\K\w+")
if [[ -z $token ]]
then
   echo "Could not obtain authentication token to elevate privileges." >&2
   exit
fi;

curl "https://$snow_instance/api/now/ui/impersonate/role" -H 'Origin: https://$snow_instance' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.9' -H 'X-WantSessionNotificationMessages: true' -H "X-UserToken: $token" -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Safari/537.36' -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept: application/json, text/plain, */*' -H 'Connection: keep-alive' --data-binary '{"roles":"security_admin"}' -b cookies.txt --cookie-jar cookies.txt --compressed -v

