# Execute script in JS directory with arguments

script_name=$1
shift

if [[ $1 == "--help" ]] || [[ $1 == "-h" ]]
then
    show_script_help=1
    shift
fi

# We need env variables beforehand
my_dir=$(dirname $0)
source $my_dir/../include/env-vars.sh

if ! [[ -e $SNOW_JS_DIR/$script_name.js ]]
then
    ENABLE_AUTOCOMPLETE=1
fi


source $my_dir/../include/env.sh

enable_autocomplete $(cd $SNOW_JS_DIR; ls *.js | sed 's/\.js//g')


add_quotes() { printf '"%s" ' "$@"; echo ""; }
args="$@"
run_script $script_name.js $(add_quotes $args) | tabularize