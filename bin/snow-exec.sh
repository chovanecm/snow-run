# Execute script in JS directory with arguments

my_dir=$(dirname $0)
source $my_dir/../include/env.sh

if [[ $1 == "--help" ]]
then
    show_script_help=1
    shift
fi

script_name=$1
shift
add_quotes() { printf '"%s" ' "$@"; echo ""; }

args="$@"

run_script $script_name.js $(add_quotes $args) | tabularize