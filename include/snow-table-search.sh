display_usage() { 
	echo "Search for ServiceNow table." 
	echo -e "\nUsage:\n$0 [-l] EXPRESSION\n"
    echo -e "\n-l:\tSearch by label instead of table name\n"  
} 

my_dir=$(dirname $0)
source $my_dir/../include/env.sh

if [ "$1" == "-l" ]
then
    search_by="label"
    shift
else
    search_by="name"
fi


x=$# check_arguments 1
name=$1
snow r search -q "${search_by}LIKE${name}" -f name,label sys_db_object --no-header
