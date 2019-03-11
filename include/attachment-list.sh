#!/bin/bash

source "$(dirname $BASH_SOURCE)/env.sh"

table=$1
limit=10


PRINT_TABLE_HEADER=true
curl "https://$snow_instance/api/now/attachment" \
--data-urlencode sysparm_query=table_name="$table" \
--data-urlencode sysparm_limit="$limit" \
-G  \
--header "Accept:application/xml" \
--user $snow_user:$snow_pwd -s | read_answer | tabularize