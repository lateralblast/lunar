lunar
=====

Lockdown UNIX Analysis Report

Usage: ./lunar [-a|c|l|h|V] [-u]

-a: Run in audit mode (no changes made to system)
<br />
-A: Run in audit mode (no changes made to system)
<br />
    [includes filesystem checks which take some time]
<br />
-s: Run in selective mode (only run tests you want to)
<br />
-S: List functions available to selective mode
<br />
-l: Run in lockdown mode (changes made to system)
<br />
-L: Run in lockdown mode (changes made to system)
<br />
    [includes filesystem checks which take some time]
<br />
-d: Show changes previously made to system
<br />
-p: Show previously versions of file
<br />
-u: Undo lockdown (changes made to system)
<br />
-h: Display usage
<br />
-V: Display version

Examples:

Display previous backups:

./lunar -b
<br />
Previous backups:
<br />
21_12_2012_19_45_05  21_12_2012_20_35_54  21_12_2012_21_57_25

Restore from previous backup:

./lunar -u 21_12_2012_19_45_05

Only run shell based tests:

./lunar -s audit_shell_services
