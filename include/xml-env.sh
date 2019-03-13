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

# private functions

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


# XML Functions
read_dom () {
    # read from stdin <entity>content</entity> to ENTITY and CONTENT variables
    local IFS=\>
    read -d \< ENTITY CONTENT
}
