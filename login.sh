if [[ -z ${snow_instance} ]];
then
    echo Set snow_instance ENV variable to something like dev123.service-now.com first!
    exit
fi

echo -n User:
read user
echo -n Password:
read -s password

export snow_cookie=$(pwd)/cookies.txt

export login_token=$(./_get-sysparm_ck.sh)
curl https://${snow_instance}/login.do -b $snow_cookie --data "sysparm_ck=$login_token&user_name=$user&user_password=$password&ni.nolog.user_password=true&ni.noecho.user_name=true&ni.noecho.user_password=true&screensize=1920x1080&sys_action=sysverb_login" --compressed -v --cookie-jar $snow_cookie > /dev/null

status=$?
if [[ $status -ne 0 ]];
then
    echo "SNOW Login not successful. curl returned $status" >&2
fi
