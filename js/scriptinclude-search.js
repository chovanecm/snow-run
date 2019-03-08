function $exec(name, operator) {
    var gr = new GlideRecord("sys_script_include");
    gr.addEncodedQuery("name" + operator + name);
    gr.query();
    while (gr.next())
        $echo(gr.name, String(gr.description).substr(0, 60))
}