display_usage() { 
	echo "Inspect given script include." 
	echo -e "\nUsage:\n$0 SCRIPT_INCLUDE_NAME\n"
    echo -e "Example:\n$0 GlideRecordUtil\n"
} 


source $(snow -I)/env.sh

x=$# check_arguments 1

name=$1

source $SNOW_INCLUDE_DIR/js-executor-env.sh

exec_sysjs_extension inspect $name | tabularize