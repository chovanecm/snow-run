function $exec(table) {
    var gr = new GlideRecord(table);
    gr.initialize();
    for (var i = 0; i < gr.getFields().size(); i++) {
        var ed = gr.getFields().get(i).getED();
        gs.print(ed + "\t" + ed.getLabel() + "\t" + ed.getInternalType());
    }
}