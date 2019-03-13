display_usage() { 
	echo "Search for ServiceNow Script Includes." 
	echo -e "\nUsage:\nsnow scriptinclude search [-e|--exact] SCRIPT_INCLUDE_NAME\n"
    exit 1
} 


my_dir=$(dirname $0)
source $my_dir/../include/env.sh
# Make sure at least one argument has been provded
x=$# check_arguments 1


# defaults: 
operator="LIKE"

while [[ $1 ]]
do
    case "$1" in
    "-e"|"--exact")
        operator="="
        ;;
    *)
        name="$1"
    esac
    shift
done

if [[ -z $name ]]; 
    then display_usage;
fi

snow r search sys_script_include -q "name${operator}${name}" -f name,description --no-header