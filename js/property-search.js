function $exec(name) {
    var gr = new GlideRecord("sys_properties");
    gr.addEncodedQuery("nameLIKE" + name);
    gr.query();
    while (gr.next()) {
        $echo(gr.name, gr.description);
    }
}

function $help() {
    $echo("Search for system properties.")
    $echo("Usage:")
    $echo("snow-exec.sh property-search cmdb")
}