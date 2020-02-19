#!/bin/bash

ENABLE_AUTOCOMPLETE=1
display_usage() { 
	echo "Delete records via REST API" 
	echo -e "\nUsage:\nsnow r delete TABLE_NAME SYS_IDS...\n"
    echo -e "\nUsage:\nsnow r delete TABLE_NAME -q|--query ENCODED_QUERY | -a|--all...\n"
    echo ""
    echo -e "Example:\n snow r delete incident afasdfsdaf4sd56fsd789 bdsaasydsasdf4567"
    echo "If no sys_ids are provided, they will be read from stdin, allowing e.g. snow r search incident --sys-id -l 10 | snow record delete incident"
    exit 1
} 





source $(snow -I)/env.sh
enable_autocomplete "--query --all --help"


table_name=$1
shift

sys_ids=()
while [[ "$1" ]]
do
    case "$1" in
    "-h"|"--help")
        display_usage
        ;;
    "-q"|"--query")
        query=$2
        shift
        ;;
    "-a"|"--all")
        query="sys_idISNOTEMPTY"
        shift
        ;;
    *)
        sys_ids+=($1)
    esac
    shift
done

if [[ -z $table_name ]]
then
    display_usage
    # and die
fi

if [[ $query ]]
then
    # Use background script to do delete by query
    echo There are $(snow record-count $table_name -q "$query") matching records in the $table_name table.
    echo -n "Delete them? [Y/N]: "
    read input
    if [[ $input == "y" ]] || [[ $input == "Y" ]]
    then
        source $SNOW_INCLUDE_DIR/js-executor-env.sh
        exec_sysjs_extension record-delete-multiple \"$table_name\" \"$query\"
    fi
else 
    # use REST API to delete each individual sys id
    if [[ ${#sys_ids[@]} -eq 0 ]]
    then
        # no sys_ids provided on command line
        while read sys_id
        do
            sys_ids+=($sys_id)
        done
    fi


    BATCH_SIZE=10 # magic constant
    # echo SysIds: ${sys_ids[@]}
    urls=()
    for sys_id in ${sys_ids[@]}
    do
        urls+=("https://$snow_instance/api/now/table/$table_name/$sys_id")
        if [[ ${#urls[@]} -ge $BATCH_SIZE ]]
        then
            curl --request DELETE --header "Accept:application/json" --user $snow_user:$snow_pwd -sS ${urls[@]}
            urls=()
        fi
    done
    if [[ $urls ]]
    then
        curl --request DELETE --header "Accept:application/json" --user $snow_user:$snow_pwd -sS ${urls[@]}
    fi
fi

