display_usage() { 
	echo "Evaluate an expression" 
	echo -e "\nUsage:\n$0 EXPRESSION\n"
    echo -e "Example:\n$0 1+1\n"
} 
my_dir=$(dirname $0)
source $my_dir/../include/env.sh

x=$# check_arguments 1

expression=$1


script=$(cat $SNOW_JS_DIR/eval.js)

echo -e "$script\n\$exec($expression)" | $my_dir/snow-run.sh -
