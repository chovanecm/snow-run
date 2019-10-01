/**
 * Update a record.
 */
function $exec(/*args*/) {
    var tableName;
    var sysId;
    var fieldName;
    var value;
    var argi = 0;
    var opts = {
        "*": function (val) {
            switch (argi) {
                case 0:
                    tableName = val;
                    break;
                case 1:
                    sysId = val;
                    break;
                case 2:
                    fieldName = val;
                    break;
                case 3:
                    value = val;
                    break;
                default:
                    $help();
                    break;
            }
            argi++;
        }
    };

    parseOpts(opts, arguments);
    
    if (tableName === null || tableName === "" || sysId === null || sysId === "") {
        return $help();
    }

    var gr = new GlideRecord(tableName);
    if (gr.get(sysId)) {
        gr.setValue(fieldName, value);
        $echo(gr.update());
    } else {
        $echo("Record not found");
    }
}

function $help() {
    $echo("Update record");
    $echo("Usage:", "snow record-update TABLE_NAME SYS_ID FIELD VALUE");
    $echo("Example:", "snow record-update incident 123456...67 active 0");
}
