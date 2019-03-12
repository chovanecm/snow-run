my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")"; pwd -P )"
export PATH=$PATH:$my_dir/bin

source $my_dir/include/autocomplete.sh


echo "ServiceNow instance(e.g. dev1234.service-now.com) [$snow_instance]:"
read r_snow_instance
if [[ -n $r_snow_instance ]]
then
    snow_instance=$r_snow_instance
    unset r_snow_instance
fi
export snow_instance



echo -n "User [$snow_user]: "
read r_snow_user
if [[ -n $r_snow_user ]]
then
    snow_user=$r_snow_user
    unset r_snow_user
fi
export snow_user



echo -n "Password: "
read -s r_snow_pwd
if [[ -n $r_snow_pwd ]]
then
    snow_pwd=$r_snow_pwd
    unset r_snow_pwd
fi
export snow_pwd


echo ""