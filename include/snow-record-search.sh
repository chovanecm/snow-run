#!/bin/bash

ENABLE_AUTOCOMPLETE=1
display_usage() { 
	echo "Search for records via REST API" 
	echo -e "\nUsage:\nsnow r search [options] TABLE_NAME\n"
    echo -e "Options:\n-q|--query ENCODED_QUERY\n-f|--fields FIELDS\n-l|--limit NUMBER\n--no-header\n--sys-id\tEquivalent to --no-header -f sys_id"
    echo Fields are returned in arbitrary order!
    echo -e "Example:\n snow r search -f name,description -q nameLIKEcmdb -l 10 sys_script_include"
    exit 1
} 



# We need env variables beforehand
my_dir=$(dirname $0)

source $my_dir/../include/env.sh
enable_autocomplete "--query --fields --limit --no-header --help"


PRINT_TABLE_HEADER=true
params=()
while [[ "$1" ]]
do
    case "$1" in
    "-q"|"--query")
        query=$2
        shift
        params+=("sysparm_query=$query")
        ;;
    "-f"|"--fields")
        fields=$2
        shift
        params+=("sysparm_fields=$fields")
        ;;
    "-l"|"--limit")
        limit=$2
        shift
        params+=("sysparm_limit=$limit")
        ;;
    "--no-header")
        PRINT_TABLE_HEADER=false
        ;;
    "--sys-id")
        params+=("sysparm_fields=sys_id")
        PRINT_TABLE_HEADER=false
        ;;
    "-h"|"--help")
        display_usage
        ;;
    *)
        table_name=$1
    esac
    shift
done


if [[ -z $table_name ]]
then
    display_usage
    # and die
fi


command_opts=""
for param in ${params[@]}
do
    command_opts+=" --data-urlencode $param"
done
command_opts+=" --data-urlencode sysparm_exclude_reference_link=true"

curl --user $snow_user:$snow_pwd -G $command_opts -H "Accept: application/xml" "https://$snow_instance/api/now/v2/table/$table_name" -sS --compressed |tr '\n' ' ' | read_answer | tabularize