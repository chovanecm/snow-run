#!/bin/bash

source "$( cd "$(dirname "${BASH_SOURCE[0]}")"; pwd -P )"/env-vars.sh

function ensure_instance_set() {
    if [[ -z ${snow_instance} ]];
    then
        echo Set snow_instance ENV variable to something like dev123.service-now.com first! >&2
        exit 1
    fi
}

function check_arguments() {
    # if less than one arguments supplied, display usage 
    if [[  $x -lt $1 ]]
    then 
        display_usage
        exit 1
    fi
}

function tabularize {
    max_len=$(tput cols)
    column -t -s $'\t' | cut -c -$max_len
}


function join_by { local IFS="$1"; shift; echo "$*"; }

function get_script {
    script_name=$1
    shift
    args="$@"
    args=$(join_by , $args)

    echo_function="
    function \$echo() {
        var \$arg = arguments;
        switch (arguments.length) {
            case 0:
                gs.print("");
                break;
            case 1:
                // *** Script: is the prefix ServiceNow normally puts at the beginning of each line. Lines that don't begin with this sequence are treated as error output.
                gs.print(arguments['0'].replace('\n', '\n*** Script: '));
                break;
            default:
                gs.print(Object.keys(\$arg).map(function (key) {return \$arg[key];}).join('\t').replace('\r', '').replace('\n', ' '));
        }
        
    }
    "
    script=$(< $SNOW_JS_DIR/$script_name)
    echo "$script"
    echo "$echo_function"
    if [[ -z $show_script_help ]]
    then
        echo "\$exec($args)"
    else
        echo "\$help()"
    fi
}
function run_script {
    # Execute script file using arguments given
    get_script "$@" | $SNOW_INCLUDE_DIR/snow-run.sh -
}


# Autocomplete helpers
# Scripts that want to provide their own autocomplete support should include this file, set ENABLE_AUTOCOMPLETE=1 and call enable_autocomplete option1 option2

# Autocomplete can be enabled for script by declaring ENABLE_AUTOCOMPLETE=1 before including this script
if ! [[ $ENABLE_AUTOCOMPLETE ]] && [[ -n $SNOW_AUTOCOMPLETE ]]
then
    # Autocomplete is not enabled by script. Do nothing
    exit 1
fi

function enable_autocomplete {
    if [[ -n $SNOW_AUTOCOMPLETE ]]
    then
        echo "$@"
        exit 1
    fi
}