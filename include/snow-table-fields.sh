display_usage() { 
	echo "Display fields defined on a given table (including inherited fields)" 
	echo -e "\nUsage:\n$0 TABLE_NAME\n"
} 

my_dir=$(dirname $0)
ENABLE_AUTOCOMPLETE=1
source $my_dir/../include/env.sh
enable_autocomplete -e snow table search -s -n 10 -f name $1


x=$# check_arguments 1
name=$1

run_script $SNOW_JS_SYS_PREFIX/table-fields.js \"$name\" | tabularize
