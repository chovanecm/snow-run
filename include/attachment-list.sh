#!/bin/bash

source "$(snow -I)/env.sh"
source $SNOW_INCLUDE_DIR/xml-env.sh

table=$1
limit=10


PRINT_TABLE_HEADER=true
curl "https://$snow_instance/api/now/attachment" \
--data-urlencode sysparm_query=table_name="$table" \
--data-urlencode sysparm_limit="$limit" \
-G  \
--header "Accept:application/xml" \
--user $snow_user:$snow_pwd -sS | read_xml_answer | tabularize