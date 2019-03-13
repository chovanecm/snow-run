display_usage() { 
	echo "Display fields defined on a given table (including inherited fields)" 
	echo -e "\nUsage:\nsnow table fields TABLE_NAME\n"
} 

# This command does support autocomplete.

ENABLE_AUTOCOMPLETE=1

source $(snow -I)/env.sh

# Enable autocomplete by offering first 10 table names matching the expression user has already typed
enable_autocomplete -e snow table search -s -n 10 -f name $1

# Check that there is at least one argument provided
x=$# check_arguments 1
name=$1

source $SNOW_INCLUDE_DIR/js-executor-env.sh

exec_sysjs_extension table-fields \"$name\" | tabularize
