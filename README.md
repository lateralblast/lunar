![alt tag](https://raw.githubusercontent.com/lateralblast/lunar/master/lunar.png)

LUNAR
=====

Lockdown UNix Auditing and Reporting

** NOTICE **
------------

Run this code in audit more only, e.g. with -a or --audit switch.
Run lockdown at your own risk. As per any system change, have backups.

I've tried to clean up this script as much as possible using shellcheck,
and I've used the -e (errexit) and -u (nounset) shell flags to help
protect against errors. The -x (xtrace) shell flag can be enabled by
using the script with the -Q or --debug flag.

If you run into errors, you can disable the -w and -u flags, by running
the script with the -q or --nostrict flag.

Version
-------

Current version 9.9.0

Refer to lunar.sh and changelog for more up to date version information

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
  - Rocky Linux
  - RHEL
  - Centos
  - Scientific Linux
  - SLES
  - Debian
  - Ubuntu
  - Amazon Linux
- Solaris
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

 -a | --audit         Run in audit mode (for Operating Systems - no changes made to system)
 -A | --fullaudit     Run in audit mode (for Operating Systems - no changes made to system)
                      [includes home directory and filesystem checks which take some time]
 -b | --backups       List backup files
 -B | --basedir       Base directory for work
 -c | --distro        Distro/Code name (used with docker/multipass)
 -C | --shell         Run docker-compose testing suite (drops to shell in order to do more testing)
 -d | --dockeraudit   Run in audit mode (for Docker - no changes made to system)
 -D | --dockertests   List all Docker functions available to selective mode
 -e | --host          Run in audit mode on external host (for Operating Systems - no changes made to system)
 -E | --hash          Password hash
 -f | --action        Action (e.g delete - used with multipass)
 -F | --tempfile      Temporary file to use for operations
 -g | --giturl        Git URL for code to copy to container
 -G | --wheelgroup    Set wheel group
 -h | --help          Display help
 -H | --usage         Display usage
 -i | --anacron       Enable/Disable anacron
 -k | --kubeaudit     Run in audit mode (for Kubernetes - no changes made to system)
 -l | --lockdown      Run in lockdown mode (for Operating Systems - changes made to system)
 -L | --fulllock      Run in lockdown mode (for Operating Systems - changes made to system)
                      [includes home directory and filesystem checks which take some time]
 -m | --machine       Create and run in a VM (docker/multipass)
 -M | --workdir       Set work directory
 -n | --ansible       Output ansible code segments
 -o | --name          Set docker/multipass OS or container name
 -O | --osinfo        Print OS information
 -p | --previous      Show previous versions of file
 -S | --unixtests     List all UNIX functions available to selective mode
 -r | --region        Specify AWS region
 -R | --testinfo      Print information for a specific test
 -s | --select        Run in selective mode (only run tests you want to)
 -t | --tag           Set docker tag
 -T | --tempdir       Set temp directory
 -u | --undo          Undo lockdown (for Operating Systems - changes made to system)
 -v | --verbose       Verbose mode [used with -a and -A]
                      [Provides more information about the audit taking place]
 -w | --awsaudit      Run in audit mode (for AWS - no changes made to system)
 -W | --awstests      List all AWS functions available to selective mode
 -V | --version       Display version
 -x | --awsrec        Run in recommendations mode (for AWS - no changes made to system)
 -z | --lockselect    Run specified audit function in lockdown mode
 -Z | --changes       Show changes previously made to system

```

Examples
--------

Perform full audit (without recursive file system checks):

```
./lunar.sh --audit
```

List tests:

```
./lunar.sh --tests
```

List AWS tests:

```
./lunar.sh --tests aws
```

Do a specific test:

```
./lunar.sh --audit --select remote_shell
```

Create a Ubuntu 24.04 multipass VM for testing:

```
./lunar.sh --action create --machine multipass --osver 24.04 
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
