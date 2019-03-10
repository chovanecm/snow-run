function $exec(name, attrs) {

    try {
        if (typeof name !== "string" || name ==="") {
            throw "No table name provided";
        }
        var args = arguments;
        var builder = Object.keys(args).slice(1).map(function (key) { return args[key] }).reduce(function (builder, arg) {
            var arr = arg.split(":");
            var fieldName = arr[0];
            var fieldType = arr[1];
            return builder.addAttribute(fieldName, fieldType);
        }, newTable(name));
        if (builder.create()) {
            $echo("OK");
        } else {
            $echo("FAIL");
        }
    } catch (e) {
        $echo("Error: " + e);
        $help();
    }
    // var result = newTable("u_pokus").addAttribute("svete", "string").create();
    // if (result === true) {
    //     $echo("OK");
    // } else {
    //     $echo("FAILED");
    // }
}

function $help() {
    $echo("Create or update ServiceNow table. EXPERIMENTAL");
    $echo("Usage:");
    $echo("table-create TABLE_NAME field_name1:field_type1 field_name2:field_type2 ...")
    $echo("")
    $echo("field_type is one of: string integer boolean glide_date glide_date_time currency price reference")
}

function newTable(tableName) {
    var obj = {
        attrs: new Packages.java.util.HashMap(),
        tableName: tableName,

        create: function () {
            var tc = new GlideTableCreator(this.tableName, this.tableName);
            tc.setColumnAttributes(this.attrs);
            // if(typeof extends_table != 'undefined')
            //       tc.setExtends(extends_table);
            tc.setOverrideUpdate(true);
            return tc.update();
        },
        addAttribute: function (fieldName, type) {
            var ca = new GlideColumnAttributes(fieldName);
            ca.setType(type);
            ca.setUsePrefix(false);
            this.attrs.put(fieldName, ca);
            return this;
        }
    };
    return obj;
}

