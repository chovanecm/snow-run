display_usage() { 
	echo "Evaluate an expression" 
	echo -e "\nUsage:\n$0 EXPRESSION\n"
    echo -e "Example:\n$0 1+1\n"
} 

# if less than one arguments supplied, display usage 
if [[  $# -lt 1 ]]
then 
    display_usage
    exit 1
fi

expression=$1

my_dir=$(dirname $0)

script="
var x = $expression;
gs.print(x);
"

echo $script | $my_dir/snow-run.sh -
