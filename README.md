![alt tag](https://raw.githubusercontent.com/lateralblast/lunar/master/lunar.png)

LUNAR
=====

Lockdown UNix Auditing and Reporting

Introduction
------------

This scripts generates a scored audit report of a Unix host's security.
It is based on the CIS and other frameworks. Where possible there are
references to the CIS and other benchmarks in the code documentation.

Why a shell script? I wanted a tool that was able to run on locked down systems
where other tools may not be available. I also wanted a tool that ran on all
versions of UNIX. Having said that there are some differences between sh and
bash, so I've used functions only from sh.

There is no warranty implied or given with this script. My recommendation
is to use this script in audit mode only, and address each warning individually
via policy, documentation and configuration management.

It can also can perform a lockdown. Unlike some other scripts I have added
capability to backout changes. Files are backed up using cpio to a directory
based on the date.

Although it can perform a lockdown, as previously stated, I'd recommend you 
address the warnings via policy, documentation and configuration management.
This is how I use the tool. The AWS Services audit only supports reporting,
it does not provide lockdown capability.

Supported Operating Systems
---------------------------

The following Operating Systems are supported:

- Linux
  - RHEL 5,6,7
  - Centos 5,6,7
  - Scientific Linux
  - SLES 10,11,12
  - Debian
  - Ubuntu
  - Amazon Linux
- Solaris (6,7,8,9,10 and 11)
- Mac OS X
- FreeBSD (needs more testing)
- AIX (needs more testing)
- ESXi (initial support - some tests)

Windows support would require the installation of additional software, so I haven't looked into it.
Having said that, Windows support may come in the future via bash.

Supported Services
------------------

Supported Services:

- AWS

The AWS Services audit uses the AWS CLI, and as such requires a user with the
appropriate rights. It does not currently support the lockdown capability,
it only supports generating an audit report against the CIS benchmark.

There are a couple of the checks that can only be done or resolved via the GUI.
An example of this is enabling billing. Refer to the CIS Benchmark for more information.

Where possible I've put suggested fix commands in the verbose audit output.
Again in some cases, these can only be done by the CLI. Refer to the CIS
Benchmark for more information.

Requirements
------------

- AWS 
  - AWS CLI
  - AWS Credentials (API Access and Secret Keys)
  - Read rights to appropriate AWS services, e.g. 
    - CloudTrail:DescribeTrails
    - Config:DescribeConfigurationRecorders
    - SNS:ListSubscriptionsByTopic

License
-------

This software is licensed as CC-BA (Creative Commons By Attrbution)

http://creativecommons.org/licenses/by/4.0/legalcode

More Information
----------------

For more information refer to wiki:

[Wiki](https://github.com/lateralblast/lunar/wiki)

[Usage](https://github.com/lateralblast/lunar/wiki/Usage)

[Ubuntu](https://github.com/lateralblast/lunar/wiki/Ubuntu)

[Solaris 11](https://github.com/lateralblast/lunar/wiki/Solaris_11)

[CentOS](https://github.com/lateralblast/lunar/wiki/CentOS)

[Amazon Linux](https://github.com/lateralblast/lunar/wiki/Amazon)

[AWS](https://github.com/lateralblast/lunar/wiki/AWS)
