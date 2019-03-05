my_dir=$(dirname $0)
source $my_dir/env.sh
curl https://$snow_instance/login.do --cookie-jar $SNOW_COOKIE_FILE | $my_dir/_grep-sysparm_ck.sh