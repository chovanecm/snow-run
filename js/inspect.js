function $exec(expression) {
    var x = expression;
    gs.print('Type:\t' + typeof x);
    if (typeof x === 'object' || typeof x === 'function') {
        gs.print('Own keys:');
        Object.keys(x).forEach(function (key) {
            gs.print(' \t' + key + '\t' + typeof x[key])
        });
        if (x.prototype !== undefined) {
            gs.print('Prototype keys:');
            Object.keys(x.prototype).forEach(function (key) {
                gs.print(' \t' + key + '\t' + typeof x.prototype[key])
            });
        }
    }
}