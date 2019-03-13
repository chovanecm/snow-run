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

function extract_sysparm_ck() {
    grep -oP 'sysparm_ck[^>]*value="\K\w+'
}

function get_login_token() {
    curl https://$snow_instance/login.do --cookie-jar $SNOW_COOKIE_FILE -sS | extract_sysparm_ck
}
function tabularize {
    max_len=$(( $(tput cols) - 1 ))
    # the ugly sed is here to prevent first line being shifted to left if the first column is empty :/
    sed 's/^\t/._\t/g' | column -t -s $'\t' -e | sed 's/^\._ /   /g' | cut -c -$max_len
}


function join_by { local IFS="$1"; shift; echo "$*"; }

function decode_html {
   sed 's/&quot;/"/g; s/&gt;/>/g'
}

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
                gs.print(arguments['0']);
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
        if [[ $1 == "-e" ]]
        then
            shift
            # Lazy - evaluate command
            # set SNOW_AUTOCOMPLETE to nothing 
            export SNOW_AUTOCOMPLETE=
            $@
            exit 1;
        else
            echo "$@"
            exit 1
        fi
    fi
}


# XML Functions


read_dom () {
    local IFS=\>
    read -d \< ENTITY CONTENT
}
print_array () {
    echo -n $1
    shift

    while [[ $1 ]]
    do
        echo -ne "\t"
        echo -n -e "$1"
        shift
    done
    echo
}
function read_row () {
    COLUMN_NAMES=()
    VALUES=()
    while read_dom && ! [[ $ENTITY == "/result" ]]
    do
        if [[ $ENTITY == /* ]]
        then
            # end tag
            continue
        fi
        if [[ $ENTITY == */ ]]
        then
            # empty tag
            ENTITY=${ENTITY::(-1)}
            CONTENT=" "
        fi
        COLUMN_NAMES+=("$ENTITY")
        VALUES+=("$CONTENT")
    done
    if [[ $PRINT_TABLE_HEADER == true ]]
    then
        print_array "${COLUMN_NAMES[@]}"
        echo
        PRINT_TABLE_HEADER=false
    fi
    print_array "${VALUES[@]}"
}
function read_answer () {
    while read_dom
    do
        if [[ $ENTITY == "result" ]]
        then
            read_row
        fi
    done
}
