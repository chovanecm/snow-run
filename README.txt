This tools aims to provide command-line interface for running locally stored ServiceNow background scripts.

Version 0.0.0

Requirements:
 - curl, bash
 - running ServiceNow instance
 - an account in ServiceNow that is capable of running background scripts

 How to:
 Set up environment:
 
 export snow_instance=dev1234.service-now.com

 Log in:

 ./login.sh

 (prepare username and password)

 ./run-script.sh example.js

 ./run-script.sh -
 (reads from STDIN; use Ctrl+D to submit the script)

 Tested with ServiceNow London release