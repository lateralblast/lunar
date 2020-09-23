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

I am by no means a coder, so there are bound to be bugs and better ways to
approach things in this script, so a sincere thank you to the people who have 
provided feedback, updates and patches to fix bugs/features in code.

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

The following services are supported:

- AWS
- Docker
- Kubernetes (not complete)
- Apache (not complete)

The AWS Services audit uses the AWS CLI, and as such requires a user with the
appropriate rights. It does not currently support the lockdown capability,
it only supports generating an audit report against the CIS benchmark.

There are a couple of the checks that can only be done or resolved via the GUI.
An example of this is enabling billing. Refer to the CIS Benchmark for more information.

Where possible I've put suggested fix commands in the verbose audit output.
Again in some cases, these can only be done by the CLI. Refer to the CIS
Benchmark for more information.

In addition I've added a recommendations mode that checks AWS against publicly
available best practice from companies like Cloud Conformity.

Configuration Management
------------------------

The following configuration management output is supported:

- Ansible

This option outputs example ansible configuration management code/stanzas
for implementing the recommendation.

Requirements
------------

For UNIX:

- Ubuntu / Debian
  - sysv-rc-conf
  - bc
  - finger

For AWS:

- AWS 
  - AWS CLI
  - AWS Credentials (API Access and Secret Keys)
  - Read rights to appropriate AWS services, e.g. 
    - CloudTrail:DescribeTrails
    - Config:DescribeConfigurationRecorders
    - SNS:ListSubscriptionsByTopic

Usage
-----

```
Usage: ./lunar.sh [OPTIONS...]

 -a   Run in audit mode (for Operating Systems - no changes made to system)
 -A   Run in audit mode (for Operating Systems - no changes made to system)
        [includes filesystem checks which take some time]
 -v   Verbose mode [used with -a and -A]
        [Provides more information about the audit taking place]
 -w   Run in audit mode (for AWS - no changes made to system)
 -d   Run in audit mode (for Docker - no changes made to system)
 -e   Run in audit mode on external host (for Operating Systems - no changes made to system)
 -k   Run in audit mode (for Kubernetes - no changes made to system)
 -x   Run in recommendations mode (for AWS - no changes made to system)
 -s   Run in selective mode (only run tests you want to)
 -l   Run in lockdown mode (for Operating Systems - changes made to system)
 -L   Run in lockdown mode (for Operating Systems - changes made to system)
        [includes filesystem checks which take some time]
 -S   List all UNIX functions available to selective mode
 -W   List all AWS functions available to selective mode
 -D   List all Docker functions available to selective mode
 -R   Print information for a specific test
 -o   Set docker OS or container name
 -t   Set docker tag
 -c   Run docker-compose testing suite (runs lunar in audit mode without making changes)
 -C   Run docker-compose testing suite (drops to shell in order to do more testing)
 -p   Show previous versions of file
 -Z   Show changes previously made to system
 -b   List backup files
 -n   Output ansible code segments
 -r   Specify AWS region
 -z   Run specified audit function
 -u   Undo lockdown (for Operating Systems - changes made to system)
 -V   Display version
 -H   Display usage
 -h   Display help
```

License
-------

This software is licensed as CC-BA (Creative Commons By Attrbution)

http://creativecommons.org/licenses/by/4.0/legalcode

More Information
----------------

For more information refer to wiki:

[Wiki](https://github.com/lateralblast/lunar/wiki)

[Usage](https://github.com/lateralblast/lunar/wiki/Usage)

[Ansible](https://github.com/lateralblast/lunar/wiki/Ansible)

[Ubuntu](https://github.com/lateralblast/lunar/wiki/Ubuntu)

[Solaris 11](https://github.com/lateralblast/lunar/wiki/Solaris_11)

[CentOS](https://github.com/lateralblast/lunar/wiki/CentOS)

[Amazon Linux](https://github.com/lateralblast/lunar/wiki/Amazon)

[AWS](https://github.com/lateralblast/lunar/wiki/AWS)

[Docker](https://github.com/lateralblast/lunar/wiki/Docker)

Testing
-------

Added a simple testing framework for debugging the lunar script itself. 
This uses docker compose to start a container, mount the lunar directory and run lunar.
