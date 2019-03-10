# default
search_by="name"
operator="LIKE"
fields="name,label"
display_usage() { 
	echo "Search for ServiceNow table."
	echo -e "Usage:\nsnow table search [-l|--label] [-s|--starts-with] [-f fields] [-n MAX_ROWS] STR"
    echo -e "\n-l:\tSearch by label instead of table name"
    echo -e "-s:\tSearch for table names starting with STR instead of containing it"
    echo -e "-f fields:\tSet fields to return. Default: $fields"
    echo -e "-n MAX_ROWS:\tMaximum number of rows to return. Default: no limit"
} 

my_dir=$(dirname $0)
source $my_dir/../include/env.sh

x=$#

while [[ "$1" ]]
do
    case "$1" in
    "-l"|"--label")
        search_by="label"
        ;;
    "-s"|"--starts-with")
        operator="STARTSWITH"
        ;;
    "-f")
        fields=$2
        shift
        ;;
    "-n")
        limit="--limit $2"
        shift
        ;;
    "-h"|"--help")
        display_usage
        ;;
    *)
        name=$1
    esac
    shift
done

check_arguments 1


snow r search -q "${search_by}${operator}${name}" $limit -f $fields sys_db_object --no-header
