/**
 * Count the number of records matching a query
 */
function $exec(/*args*/) {
    var tableName;
    var encodedQuery;
    var opts = {
        "-q": "--query",
        "--query": function (query) {
            encodedQuery = query;
        },
        "*": function (name) {
            tableName = name;
        }
    }

    parseOpts(opts, arguments);
    
    if (tableName === null || tableName === "") {
        return $help();
    }

    var gr = new GlideAggregate(tableName);
    gr.addEncodedQuery(encodedQuery);
    gr.addAggregate("COUNT");
    gr.query();
    if (gr.next()) {
        $echo(gr.getAggregate("COUNT"));
    }
    
}

function $help() {
    $echo("Count the number of records")
    $echo("Usage:", "snow record-count [-q|--query] TABLE_NAME")
    $echo("Example:", "snow record-count -q sys_created_on>=2018-01-01 incident")
}
