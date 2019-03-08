function $exec(name, operator) {
    var gr = new GlideRecord("sys_script_include");
    gr.addEncodedQuery("name" + operator + name);
    gr.query();
    while (gr.next())
        gs.print(gr.name + "\t" + String(gr.description).substr(0, 60))
}