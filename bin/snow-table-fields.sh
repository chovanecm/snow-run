display_usage() { 
	echo "Display fields defined on a given table (including inherited fields)" 
	echo -e "\nUsage:\n$0 TABLE_NAME\n"
} 

my_dir=$(dirname $0)
source $my_dir/../include/env.sh

x=$# check_arguments 1
name=$1

run_script $SNOW_JS_SYS_PREFIX/table-fields.js \"$name\" | tabularize
