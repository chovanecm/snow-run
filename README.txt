This tools aims to provide command-line interface for running locally stored ServiceNow background scripts.

Version 0.0.0

Requirements:
 - curl, bash
 - a running ServiceNow instance
 - an account in ServiceNow that is capable of running background scripts

 How to:
 Set up environment:
 
 export snow_instance=dev1234.service-now.com

 Log in:

 ./snow-login.sh

 (prepare your username and password)

If your instance requires the security_admin role to run background scripts, run:
 ./snow-elevate.sh

Running scripts:

 ./snow-run.sh example.js

 ./snow-run.sh -
 (reads from STDIN; use Ctrl+D to submit the script)

 Tested with ServiceNow London release, however, it's just a proof of concept.

Additional scripts:
 ./snow-info.sh displays information about current settings and the temporary directory used to store cookies.
 
 snow-scriptinclude-search.sh SCRIPT_NAME
   Search for script includes containing SCRIPT_NAME in their name
 snow-inspect.sh EXPRESSION
   Displays overview of an object returned by the expression, e.g. its type, own keys and prototype keys.
   Useful for inspecting script includes.
   USE WITH CAUTION! Especially if the expression has side effects.
 snow-eval.sh EXPRESSION
   Evaluates expression and prints the output. Note: Don't forget to properly escape strings for Bash. (e.g. snow-eval.sh '"Hello"' or snow-eval.sh \"Hello\")
   USE WITH CAUTION! Especially if the expression has side effects.
 snow-table-search.sh [-l] EXPRESSION
    Search for table name
 snow-table-fields.sh TABLE_NAME
    Display fields defined on a given table (including inherited fields)
 
 Any script from the "js" folder can be IN THEORY run without writing the extension, e.g.
  snow-exec.sh property-search EXPRESSION
    Displays system properties containing EXPRESSION in their name
  snow-exec.sh --help property-search
    Displays help for property-search 
  
  *** Scripts that have an corresponding snow-SCRIPT_NAME.sh helper script are not intended to be run with snow-exec.sh ***
