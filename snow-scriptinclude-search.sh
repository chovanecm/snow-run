name=${1:-""}
if [[ -z "$name" ]]
then
    echo -n "Name of the script include to search for: "
    read name
fi;


my_dir=$(dirname $0)

echo "var gr=new GlideRecord(\"sys_script_include\"); gr.addEncodedQuery(\"nameLIKE$name\"); gr.query(); while (gr.next()) gs.print(gr.name + \"\\t\" + String(gr.description).substr(0, 60))" | $my_dir/snow-run.sh - | column -t -s $'\t'