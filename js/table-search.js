function $exec(field, value) {
    var gr = new GlideRecord("sys_db_object");
    gr.addEncodedQuery(field + "LIKE" + value);
    gr.query();
    while (gr.next()) {
        gs.print(gr.name + "\t" + String(gr.label).substr(0, 60))
    }
}
