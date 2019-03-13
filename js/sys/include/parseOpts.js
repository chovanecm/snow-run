/**
     * Parse arguments passed to the $exec function
     * 
     * Example usage:
     * <pre>
        function $exec() {
            var firstName;
            var lastName;
            var location;
            var opts = {
                // enable option name to be called as follows: --name John Doe
                "--name": function (_firstName, _lastName) { 
                    firstName = _firstName;
                    lastName = _lastName;
                },
                // set -n to be alias for --name, thus allowing: -n John Doe
                "-n": "--name",
                // default (no keyword)
                "*": function (value) {
                    location = value;
                }
            };
            // This allows $exec to accept arguments like $exec("Prague", "-n", "John", "Doe")
            // which is equivalent to executing the extension with snow ... Prague -n John Doe or snow ... -n John Doe Prague
        }
        // this will parse the arguments according to specification
        parseOpts(opts, arguments);
     * </pre>
     */
function parseOpts(opts, args) {
    for (var i = 0; i < args.length; i++) {
        var arg = args[i];
        if (opts[arg] === undefined) {
            opts["*"](arg);
        } else if (typeof opts[arg] === "string") {
            // alias for another command (e.g. -q to --query)
            arg = opts[arg];
        }
        var fn = opts[arg];
        var numberOfFnArguments = fn.length;
        var fnArguments = [];
        while (numberOfFnArguments > 0 && i < args.length - 1) {
            numberOfFnArguments--;
            i++;
            fnArguments.push(args[i]);
        }
        fn.apply(null, fnArguments);
    }
}