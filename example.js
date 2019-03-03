var gr = new GlideRecord("incident");
gr.query();
gs.print("There are " + gr.getRowCount() + " records in the incident table.");

gs.print("Current user: " + gs.getUserName())