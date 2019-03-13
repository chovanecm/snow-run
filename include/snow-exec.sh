# Execute JS-based extension

# Usage: snow-exec.sh EXTENSION_NAME [-h|--help] ARGS...
# the EXTENSION_NAME must match any of the .js files in "js" directory
# e.g. snow-exec.sh property-search => there must be a file js/property-search.js

# Extensions must implement certain interface to work correctly. See README

function display_usage() {
    echo "Execute an extension script"
    echo "Usage: snow exec EXTENSION_NAME args..."
    echo "Alternative usage: snow EXTENSION_NAME args..."
}

script_name=$1

if [[ $2 == "--help" ]] || [[ $2 == "-h" ]]
then
    show_script_help=1
fi

# Here, we are explicitly calling env-vars to read environment variables that we need to determine ENABLE_AUTOCOMPLETE
source $(snow -I)/env-vars.sh

if ! [[ -e $SNOW_JS_DIR/$script_name.js ]]
then
    # The EXTENSION_NAME is not a valid extension script. Let's enable autocompletion 
    ENABLE_AUTOCOMPLETE=1
fi

source $SNOW_INCLUDE_DIR/env.sh
x=$# check_arguments 1

#  These are the options
enable_autocomplete $(cd $SNOW_JS_DIR; ls *.js | sed 's/\.js//g')


source $SNOW_INCLUDE_DIR/js-executor-env.sh

if [[ -z $show_script_help ]]
then
    exec_js_extension "$@" | tabularize
else
    exec_js_extension_help $script_name | tabularize
fi

