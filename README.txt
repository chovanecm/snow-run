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

 ./login.sh

 (prepare your username and password)

 ./snow-run.sh example.js

 ./snow-run.sh -
 (reads from STDIN; use Ctrl+D to submit the script)

 Tested with ServiceNow London release, however, it's just a proof of concept.