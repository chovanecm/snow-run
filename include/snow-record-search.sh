#!/bin/bash

ENABLE_AUTOCOMPLETE=1
display_usage() { 
	echo "Search for records via REST API" 
	echo -e "\nUsage:\nsnow r search [options] TABLE_NAME\n"
    echo -e "Options:\n-q|--query ENCODED_QUERY\n-o|--order-by FIELD\n-od|--order-by-desc FIELD\n-f|--fields FIELDS\n-l|--limit NUMBER\n--no-header\n--sys-id\tEquivalent to --no-header -f sys_id"
    echo Fields are returned in arbitrary order
    echo -e "Example:\n snow r search incident -l 10"
    echo -e "Advanced example:\n snow r search -f name,description -q nameLIKEcmdb -l 10 sys_script_include -o name -od sys_created_on"

    exit 1
} 


source $(snow -I)/env.sh
source $SNOW_INCLUDE_DIR/xml-env.sh

enable_autocomplete "--query --fields --limit --no-header --help --sys-id --order-by --order-by-desc"


PRINT_TABLE_HEADER=true
params=()
ORDER_BY=()
ENCODED_QUERY=()
while [[ "$1" ]]
do
    case "$1" in
    "-q"|"--query")
        query=$2
        shift
        ENCODED_QUERY+=($query)
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
    "-o"|"--order-by")
        ORDER_BY+=("ORDERBY$2")
        shift
        ;;
    "-od"|"--order-by-desc")
        ORDER_BY+=("ORDERBYDESC$2")
        shift
        ;;
    "--sys-id"|"--sys-ids")
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

if [[ ${#ORDER_BY[@]} -gt 0 ]]
then
    ENCODED_QUERY+=($(join_by "^" ${ORDER_BY[@]}))
fi


params+=("sysparm_query=$(join_by '^' ${ENCODED_QUERY[@]})")

command_opts=""
for param in ${params[@]}
do
    command_opts+=" --data-urlencode $param"
done
command_opts+=" --data-urlencode sysparm_exclude_reference_link=true"

curl ${CURL_OPTIONS} --user $snow_user:$snow_pwd -G $command_opts -H "Accept: application/xml" "https://$snow_instance/api/now/v2/table/$table_name" -sS --compressed \
 | tr '\r\n' '  ' | read_xml_answer | decode_html | tabularize