![alt tag](https://raw.githubusercontent.com/richardatlateralblast/lunar/master/lunar.png)

LUNAR
=====

Lockdown UNix Auditing and Reporting

Introduction
------------

This scripts generates a scored audit report of a Unix host's security.
It is based on the CIS and other frameworks.

Why a shell script? I wanted a tool that was able to run on locked down systems
where other tools may not be available. I also wanted a tool that ran on all
versions of UNIX. Having said that there are some differences between sh and
bash, so I've used functions only from sh.

It can also can perform a lockdown. Unlike some other scripts I have added
capability to backout changes. Files are backed up using cpio to a directory
based on the date (see Examples below).

Supported Operating Systems:

- Linux
  - Red Hat
  - Centos
  - Scientific Linux
  - SLES
  - Debian
  - Ubuntu
- Solaris (6,7,8,9,10 and 11)
- Mac OS X
- FreeBSD (needs more testing)
- AIX (needs more testing)
- ESXi (initial support - some tests)

License
-------

License
-------

This software is licensed as CC-BA (Creative Commons By Attrbution)

http://creativecommons.org/licenses/by/4.0/legalcode

More Information
----------------

For more information refer to wiki:

https://github.com/richardatlateralblast/lunar/wiki

Usage:

https://github.com/richardatlateralblast/lunar/wiki/usage

Ubuntu:

https://github.com/richardatlateralblast/lunar/wiki/ubuntu

Solaris 11:

https://github.com/richardatlateralblast/lunar/wiki/solaris11

CentOS:

https://github.com/richardatlateralblast/lunar/wiki/centos
