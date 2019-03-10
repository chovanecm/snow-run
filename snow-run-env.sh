my_dir="$( cd "$(dirname "${BASH_SOURCE[0]}")"; pwd -P )"
export PATH=$PATH:$my_dir/bin

source $my_dir/include/autocomplete.sh

if [[ -z $snow_instance ]]
then
    echo -n "ServiceNow instance (e.g. dev1234.service-now.com): "
    read snow_instance
    export snow_instance
fi


if [[ -z $snow_user ]]
then
    echo -n "User: "
    read snow_user
    export snow_user
fi

if [[ -z $snow_pwd ]]
then
    echo -n "Password: "
    read -s snow_pwd
    export snow_pwd
fi

echo ""