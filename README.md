lunar
=====

Lockdown UNIX Analysis Report

Usage: ./lunar [-a|c|l|h|V] [-u]

-a: Run in audit mode (no changes made to system)
-A: Run in audit mode (no changes made to system)
    [includes filesystem checks which take some time]
-s: Run in selective mode (only run tests you want to)
-S: List functions available to selective mode
-l: Run in lockdown mode (changes made to system)
-L: Run in lockdown mode (changes made to system)
    [includes filesystem checks which take some time]
-d: Show changes previously made to system
-p: Show previously versions of file
-u: Undo lockdown (changes made to system)
-h: Display usage
-V: Display version

Examples:

Display previous backups:

./lunar -b
Previous backups:
21_12_2012_19_45_05  21_12_2012_20_35_54  21_12_2012_21_57_25

Restore from previous backup:

./lunar -u 21_12_2012_19_45_05

Only run shell based tests:

./lunar -s audit_shell_services
