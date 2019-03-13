function $exec(expression) {
    var x = expression;
    gs.print('Type:\t' + typeof x);
    if (typeof x === 'object' || typeof x === 'function') {
        $echo('Own keys:');
        Object.keys(x).forEach(function (key) {
            $echo('.', key, typeof x[key]);
        });
        if (x.prototype !== undefined) {
            $echo('Prototype keys:');
            Object.keys(x.prototype).forEach(function (key) {
                $echo('.', key, typeof x.prototype[key]);
            });
        }
    }
}