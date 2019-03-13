#!/bin/bash

source "$( cd "$(dirname "${BASH_SOURCE[0]}")"; pwd -P )"/env-vars.sh

function ensure_instance_set() {
    # Check whether we know the ServiceNow instance to talk to; if not, exit.
    if [[ -z ${snow_instance} ]];
    then
        echo Set snow_instance ENV variable to something like dev123.service-now.com first! >&2
        exit 1
    fi
}

function check_arguments() {
    # if less than $1 arguments supplied, display usage 
    if [[  $x -lt $1 ]]
    then 
        display_usage
        exit 1
    fi
}

function extract_sysparm_ck() {
    # ServiceNow sometimes requests browser to include a token when sending forms.
    # This is the way to read it from a web page
    grep -oP 'sysparm_ck[^>]*value="\K\w+'
}

function get_login_token() {
    curl https://$snow_instance/login.do --cookie-jar $SNOW_COOKIE_FILE -sS | extract_sysparm_ck
}

function tabularize {
    # Takes the input and splits it by tabulators into columns. 
    # To prevent table from wrapping to the next line, everything longer than the current terminal size is ignored.

    max_len=$(( $(tput cols) - 1 ))
    column -t -s $'\t' -e | cut -c -$max_len
}


function join_by {
     # Join array using a delimiter
     # Example: 
     # arr = (hello world)
     # join_by , ${arr[@]} => "hello,world"

     local IFS="$1"; shift; echo "$*"; 
     }

function decode_html {
    # Decode (some) special HTML characters
   sed 's/&quot;/"/g; s/&gt;/>/g'
}



# Autocomplete helpers
# Scripts that want to provide their own autocomplete support should include this file, set ENABLE_AUTOCOMPLETE=1 and call enable_autocomplete option1 option2

# Autocomplete can be enabled for script by declaring ENABLE_AUTOCOMPLETE=1 before including this script
if ! [[ $ENABLE_AUTOCOMPLETE ]] && [[ -n $SNOW_AUTOCOMPLETE ]]
then
    # Autocomplete is not enabled by script but it was requested to provide hints
    # Just leave.
    exit 1
fi

function enable_autocomplete {
    # enable_autocomplete option1 option2 option3
    # - when SNOW_AUTOCOMPLETE is set, the program will output the options provided as arguments and exit
    # enable_autocomplete -e ls js/
    # - when SNOW_AUTOCOMPLETE is set, the program will execute the command following -e, whose output will be used for autocompletion
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
    # read from stdin <entity>content</entity> to ENTITY and CONTENT variables
    local IFS=\>
    read -d \< ENTITY CONTENT
}

print_array () {
    # print arguments provided separated by a TAB
    # print_array Hello World
    echo -n "$1"
    shift

    while [[ $1 ]]
    do
        echo -ne "\t"
        echo -n -e "$1"
        shift
    done
    echo
}

function read_xml_result_row () {
    # Print contnets of each element until </result> is reached
    # Don't call directly, see read_xml_answer
    
    # PRINT_TABLE_HEADER=true causes the table header to be printed as well
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
function read_xml_answer () {
    # Very simple XML parser for XML responses received from ServiceNow REST API
    # Example:
    # echo "<result><hello>world</hello><brno>mesto</brno></result><result><hello>svete</hello><brno>statl</brno></result>" | PRINT_TABLE_HEADER=true read_xml_answer
    # Produces: 
    # hello   brno

    # world   mesto
    # svete   statl
    # --------------
    # Constraints: Each "result" must contain the same set of elements in the same order
    # empty values must be written as <entity /> or <entity></entity>
    # elements under <result> should have no other child elements than text (no nested elements allowed)
    while read_dom
    do
        if [[ $ENTITY == "result" ]]
        then
            read_xml_result_row
        fi
    done
}
