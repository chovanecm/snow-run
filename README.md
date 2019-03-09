# Snow-Run

This tools aims to provide command-line interface for running locally stored ServiceNow background scripts.

Version 0.0.1

Requirements:
 - curl, bash
 - a running ServiceNow instance
 - an account in ServiceNow that is capable of running background scripts

# Warnings

***Never ever try running anything of this against your production instance.***

***Never ever allow anyone to steal your cookies (see bellow).***

YOU HAVE BEEN WARNED!

# Instructions

## Setting up Environment
1. Set your instance
 
 *Preferrably, avoid using the tool with production instances.*

 ```shell
 export snow_instance=dev1234.service-now.com
 ```

2. Get scripts on your PATH and enable autocompletion
```shell
source snow-run-env.sh
```

3. Log in:

```shell
snow login
```

The script asks for your username and password.
This will create a directory under your `$HOME` which stores the session and other cookies.

You can display path to the directory with `snow info`:
```console
you@machine:~$ snow info
SNOW RUN against dev1234.service-now.com instance.
Temp directory: /home/you/.snow-run/tmp/dev1234.service-now.com
Protect that directory from being read by others.
```

4. Elevate roles (if needed)
If your instance requires the `security_admin` role to run background scripts, you might need to elevate roles for the user:
```shell
snow elevate
```

## Usage

### Running arbitrary background script

You can run arbitrary background script stored on your computer as if you entered it into the background script form in ServiceNow:

```shell
snow run FILE
# or write the script directly in console:
snow run -
# the - sign tells the tool to read from standard input
```

Example:
 ```console
you@machine:~$ snow run example.js
There are 54 records in the incident table.
Current user: admin
```

***Known issue: `gs.print()` does currently not handle multi-line output well.***
`gs.print("Hello\nWorld")` would print `World` to the error output.

### Useful scripts

#### Searching for script includes by name

```shell
snow scriptinclude search STRING
```

Example:
 ```console
you@machine:~$ snow scriptinclude search cmdb
DiscoveryCMDBUtil            This class contains useful utility functions for interacting with the CMDB API for identification and reconciliation.
CMDBDuplicateRemediatorUtil  Utility  for the CMDB Duplicate Remediator
CMDBRelationshipAjax         Returns available CMDB relationships
CMDBHealthTaskTables         Task tables involved in CMDB Health Audit and Dashboarding
CMDBDuplicateTaskUtils       Utility class to manually create Remediate Duplicate Task with duplicates that are of independent type
CMDBTransformUtil            CMDB Utility class for calling Identification and Reconciliation API within transform maps
CMDBAccessCheckUtil          Utility function for CMDB access check.
CMDBItem                     Class for Configuration Item helper functions
```

### Inspecting a script include or another object

```shell
snow inspect snow inspect SCRIPT_INCLUDE_OR_EXPRESSSION
```

Example:
 ```console
you@machine:~$ snow inspect GlideRecordUtil
Type:            function
Own keys:
Prototype keys:
                 initialize                 function
                 getCIGR                    function
                 getGR                      function
                 getFields                  function
                 populateFromGR             function
                 mergeToGR                  function
                 getTables                  function
                 getGlideRecordByAttribute  function
                 type                       string
```
***Use with caution. You can accidentaly execute code with side effects!***

### Evaluating an Expression

```shell
snow eval EXPR
```

Example:
 ```console
you@machine:~$ snow eval 1+1
2
you@machine:~$ snow eval 'gs.getUserName()'
admin
```
***Use with caution. You can accidentaly execute code with side effects!***

### Searching for Tables
```shell
snow table search [-l] STRING
```

By default, this command searches for table names containing `STRING`. The `-l` option changes the behavior to search in table labels.

Example:
 ```console
you@machine:~$ snow table search properties
cmdb_properties              CMDB Properties
sys_properties_category      System Property Category
sys_properties               System Property
std_change_properties        Standard Change Properties
sys_properties_category_m2m  Category Property

you@machine:~$ snow table search -l properties # Searching by label
cmdb_properties        CMDB Properties
std_change_properties  Standard Change Properties
```

### Listing Table Fields
```shell
snow table fields TABLE_NAME
```

This will produce output of all fields on the table (including inhertied fields), their labels and data type.

Example:
```console
you@machine:~$ snow table fields incident
parent                    Parent                    reference
made_sla                  Made SLA                  boolean
caused_by                 Caused by Change          reference
watch_list                Watch list                glide_list
upon_reject               Upon reject               string
sys_updated_on            Updated                   glide_date_time
(…)
```

### Extensions

Besides running arbitrary scripts with `snow run FILE`, which don't require any special modification, the tool also allows for writing custom extensions.

Extensions are regular JavaScript files implementing certain interface and stored in the `js` subdirectory of the project.

Each extension must declare and implement the following method:
```javascript
function $exec(/* any number of arguments */) {
   // any ServiceNow-compatible JavaScript code
}
```

#### Example 1 - File `js/hello.js` without Arguments:
```javascript
function $exec() {
   gs.print("Hello!");
}
```
Such script can be executed in two interchangeable ways:
```shell
snow exec hello
# Or simply
snow hello
```

```console
you@machine:~$ snow hello
Hello!
```

#### Example 2 - File `js/hello-name.js` with Arguments:
```javascript
function $exec(firstname, lastname) {
   gs.print("Hello " + firstname + " " + lastname);
}
```
All arguments are passed as strings automatically:

```console
you@machine:~$ snow hello-name John Doe
Hello John Doe
```

#### Example 3 - File `js/echo.js` Formatted Output:

Any output produced by extensions is automatically formatted as table with columns identified by tabulator (`\t`).
Instead of producing output with TABs manually, the `$echo(/* any number of arguments */)` function can be called with any number of arguments representing columns. Unless only one argument is provided, any new-lines strings are automatically converted to spaces to prevent the resulting table from being wrapped to the next line.
If this is not the desired behaviour, call `$echo("This is \n New line)` instead.

The `$echo()` function with one argument will correctly print strings with new-lines characters.

When using `gs.print()` instead, every line but the first one is treated as error output.

```javascript
function $exec(firstname, lastname) {
    $echo(1, firstname, lastname);
    // equivalent to:
    // gs.print("1\t" + firstname + "\t" + lastname)
    $echo(2, "Jan", "Jesenius\nNotANewLine");
    $echo("New\nline");
 }
 ```
 
```console
you@machine:~$ snow echo John Doe
1     John  Doe
2     Jan   Jesenius NotANewLine
New
line
```

#### Example 4 - File `js/echo.js` with Help on Usage:

Extensions can define their own `$help()` function to print usage when the script is invoked with either `--help` or `-h`.

*Note: The help function is also executed remotely!*

```javascript
function $exec(firstname, lastname) {
    $echo(1, firstname, lastname);
    // equivalent to:
    // gs.print("1\t" + firstname + "\t" + lastname)
    $echo(2, "Jan", "Jesenius\nNotANewLine");
    $echo("New\nline");
 }
 
function $help() {
    $echo("Print out name and some stuff around");
    $echo("Usage: fistName, lastName");
}
 ```
 
```console
you@machine:~$ snow echo -h
Print out name and some stuff around
Usage: fistName, lastName
New
line
```


