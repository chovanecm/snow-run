display_usage() { 
	echo "Display fields defined on a given table (including inherited fields)" 
	echo -e "\nUsage:\n$0 TABLE_NAME\n"
} 

# if less than one arguments supplied, display usage 
if [[  $# -lt 1 ]]
then 
    display_usage
    exit 1
fi

name=$1

my_dir=$(dirname $0)

script="
var gr=new GlideRecord(\"${name}\");
gr.initialize();
for (var i = 0; i < gr.getFields().size(); i++) {
    var ed = gr.getFields().get(i).getED();
    gs.print(ed + \"\\t\" + ed.getLabel() + \"\\t\" + ed.getInternalType());
}
"

echo $script | $my_dir/snow-run.sh - | column -t -s $'\t'
