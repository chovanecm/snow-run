display_usage() { 
	echo "Inspect given script include." 
	echo -e "\nUsage:\n$0 SCRIPT_INCLUDE_NAME\n"
    echo -e "Example:\n$0 GlideRecordUtil\n"
} 

my_dir=$(dirname $0)
source $my_dir/../include/env.sh

x=$# check_arguments 1

name=$1

run_script inspect.js $name | tabularize