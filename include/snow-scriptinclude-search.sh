display_usage() { 
	echo "Search for ServiceNow Script Includes." 
	echo -e "\nUsage:\n$0 [--exact] SCRIPT_INCLUDE_NAME\n"
} 

if [[ "$1" == "--exact" ]]
then
    operator="="
    shift
else
    operator="LIKE"
fi

my_dir=$(dirname $0)
source $my_dir/../include/env.sh
x=$# check_arguments 1

name=$1

snow r search sys_script_include -q "name${operator}${name}" -f name,description --no-header