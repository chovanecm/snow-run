display_usage() { 
	echo "Search for ServiceNow Script Includes." 
	echo -e "\nUsage:\n$0 [--exact] SCRIPT_INCLUDE_NAME\n"
} 

if [[ "$1" == "--exact" ]]
then
    operator="="
    shift
else
    operator="LIKE"
fi

# if less than two arguments supplied, display usage 
if [[  $# -lt 1 ]]
then 
    display_usage
    exit 1
fi

name=$1

my_dir=$(dirname $0)
echo "var gr=new GlideRecord(\"sys_script_include\"); gr.addEncodedQuery(\"name$operator$name\"); gr.query(); while (gr.next()) gs.print(gr.name + \"\\t\" + String(gr.description).substr(0, 60))" | $my_dir/snow-run.sh - | column -t -s $'\t'