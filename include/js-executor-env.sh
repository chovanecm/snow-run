
function exec_js_extension() {
    # Execute user-defined extension in "js" directory
    # ARGS are automatically treated as strings
    # exec_extension EXTENSION_NAME ARGS...
    # EXTENSION_NAME is a file name in the "js" directory without the ".js" extension, e.g. property-search

    cat $(get_extension_file "$1") | add_extension_api | add_exec_call $(add_quotes ${@:2}) | execute_background_script
}

function exec_js_extension_help() {
    # Execute help for user-defined extension in "js" directory
    # extension_show_help EXTENSION_NAME
    cat $(get_extension_file "$1") | add_extension_api | add_help_call | execute_background_script
}

function exec_sysjs_extension() {
    # See exec_js_extension
    # Differences: arguments are passed 'as they are' (as literals, not as strings) and the scripts are searched in js/sys directory
    cat $(get_sys_extension_file "$1") | add_extension_api | add_exec_call ${@:2} | execute_background_script
}


function exec_sysjs_extension_help() {
    cat $(get_sys_extension_file "$1") | add_extension_api | add_help_call | execute_background_script
}


# private functions

source $(snow -I)/env-vars.sh

add_quotes() { printf '"%s" ' "$@"; echo ""; }

function get_extension_file () {
    echo $SNOW_JS_DIR/$1.js
}

function get_sys_extension_file {
    echo $SNOW_JS_SYS_DIR/$1.js
}

function add_extension_api {
    cat -
     echo_function="
    function \$echo() {
        var \$arg = arguments;
        switch (arguments.length) {
            case 0:
                gs.print("");
                break;
            case 1:
                gs.print(arguments['0']);
                break;
            default:
                gs.print(Object.keys(\$arg).map(function (key) {return \$arg[key];}).join('\t').replace('\r', '').replace('\n', ' '));
        }
        
    }
    "

    echo "$echo_function"
    cat $SNOW_JS_SYS_DIR/include/parseOpts.js
}

function add_exec_call {
    # Translates command line parameters to what a JS extension expects
    # Example: translate_arguments_to_extension_script_call "Hello" "World" => $exec("Hello", "World");
    cat -
    args="$@"
    echo "\$exec($(join_by , $args));"
}

function add_help_call {
    cat -
    echo "\$help()"
}


function execute_background_script {
    snow run
}