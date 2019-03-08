function $exec(field, value) {
    var gr = new GlideRecord("sys_db_object");
    gr.addEncodedQuery(field + "LIKE" + value);
    gr.query();
    while (gr.next()) {
        $echo(gr.name, String(gr.label))
    }
}
