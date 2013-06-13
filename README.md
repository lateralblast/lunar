lunar
=====

Lockdown UNix Auditing and Reporting

This scripts generates a scored audit report of a Unix host's security.
It is based on the CIS and other frameworks.

It can also can perform a lockdown. Unlike some other scripts I have added
capability to backout changes. Files are backed up using cpio to a directory
based on the date (see Examples below).

Supported Operating Systems:

Linux (Red Hat 5.x, Red Hat 6.x, Debian, and Ubuntu), Solaris (6,7,8,9,10 and 11), and Mac OS X


Usage 
-----

	./lunar [-a|c|l|h|V] [-u]

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
	-v: Verbose mode [used with -a and -A]
	    [Provides more information about the audit taking place]


Examples
--------

Run in Audit Mode:

	./lunar -a

Run in Audit Mode and provide more information:

	./lunar -a -v

Display previous backups:

	./lunar -b
	Previous backups:
	21_12_2012_19_45_05  21_12_2012_20_35_54  21_12_2012_21_57_25

Restore from previous backup:

	./lunar -u 21_12_2012_19_45_05

List tests:

	./lunar -S

Only run shell based tests:

	./lunar -s audit_shell_services
