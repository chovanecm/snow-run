if [ "$1" == "-l" ]
then
    search_by="label"
    shift
else
    search_by="name"
fi



display_usage() { 
	echo "Search for ServiceNow table." 
	echo -e "\nUsage:\n$0 [-l] EXPRESSION\n"
    echo -e "\n-l:\tSearch by label instead of table name\n"  
} 

# if less than two arguments supplied, display usage 
if [[  $# -lt 1 ]]
then 
    display_usage
    exit 1
fi

name=$1

my_dir=$(dirname $0)

echo "var gr=new GlideRecord(\"sys_db_object\"); gr.addEncodedQuery(\"${search_by}LIKE$name\"); gr.query(); while (gr.next()) gs.print(gr.name + \"\\t\" + String(gr.label).substr(0, 60))" | $my_dir/snow-run.sh - | column -t -s $'\t'
