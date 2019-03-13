display_usage() { 
	echo "Evaluate an expression" 
	echo -e "\nUsage:\n$0 EXPRESSION\n"
    echo -e "Example:\n$0 1+1\n"
} 

source $(snow -I)/env.sh
x=$# check_arguments 1

source $SNOW_INCLUDE_DIR/js-executor-env.sh

expression=$1
exec_sysjs_extension eval $expression
