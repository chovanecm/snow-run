function $exec(tableName, encodedQuery) {
    var gr = new GlideRecord(tableName);
    gr.addEncodedQuery(encodedQuery);
    gr.query();
    gr.deleteMultiple();
}