display_usage() { 
	echo "Inspect given script include." 
	echo -e "\nUsage:\n$0 SCRIPT_INCLUDE_NAME\n"
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
var x = $name;
gs.print('Type:\t' + typeof x);
if (typeof x === 'object' || typeof x === 'function') {
    gs.print('Own keys:');
    Object.keys(x).forEach(function (key) {
        gs.print(' \t' + key + '\t' + typeof x[key])
    });
    if (x.prototype !== undefined) {
        gs.print('Prototype keys:');
        Object.keys(x.prototype).forEach(function (key) {
            gs.print(' \t' + key + '\t' + typeof x.prototype[key])
        });
    }
}
"

echo $script | $my_dir/snow-run.sh - | column -t -s $'\t'
