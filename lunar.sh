#!/bin/sh

# Name:         lunar (Lockdown UNix Auditing and Reporting)
# Version:      7.7.5
# Release:      1
# License:      CC-BA (Creative Commons By Attribution)
#               http://creativecommons.org/licenses/by/4.0/legalcode
# Group:        System
# Source:       N/A
# URL:          http://lateralblast.com.au/
# Distribution: Solaris, Red Hat Linux, SuSE Linux, Debian Linux,
#               Ubuntu Linux, Mac OS X, AIX, FreeBSD, ESXi
# Vendor:       UNIX
# Packager:     Richard Spindler <richard@lateralblast.com.au>
# Description:  Audit script based on various benchmarks
#               Addition improvements added
#               Written in bourne shell so it can be run on different releases

# No warranty is implied or given with this script
# It is based on numerous security guidelines
# As with any system changes, the script should be vetted and
# changed to suit the environment in which it is being used

# Unless your organization is specifically using the service, disable it.
# The best defense against a service being exploited is to disable it.

# Even if a service is set to off the script will audit the configuration
# file so that if a service is re-enabled the configuration is secure
# Where possible checks are made to make sure the package is installed
# if the package is not installed the checks will not be run

# To do:
#
# - nosuid,noexec for Linux
# - Disable user mounted removable filesystems for Linux
# - Disable USB devices for Linux
# - Grub password
# - Restrict NFS client requests to privileged ports Linux

# Solaris Release Information
#  1/06 U1
#  6/06 U2
# 11/06 U3
#  8/07 U4
#  5/08 U5
# 10/08 U6
#  5/09 U7
# 10/09 U8
#  9/10 U9
#  8/11 U10
#  1/13 U11

# audit_mode = 1 : Audit Mode
# audit_mode = 0 : Lockdown Mode
# audit_mode = 2 : Restore Mode

# Defaults for AWS

aws_iam_master_role="iam-master"
aws_iam_manager_role="iam-manager"
aws_cloud_trail_name="aws-audit-log"
sns_protocol="email"
sns_endpoint="alerts@company.com"
valid_tag_string="(ue1|uw1|uw2|ew1|ec1|an1|an2|as1|as2|se1)-(d|t|s|p)-([a-z0-9\-]+)$"
strict_valid_names="y"
check_volattach="y"
check_voltype="y"
check_snapage="y"
aws_region=""
aws_rds_min_retention="7"
aws_ec2_min_retention="7"
aws_ec2_max_retention="30"
aws_days_to_key_deletion="7"

# Set up some global variables

app_dir=$( dirname $0 )
args=$@
secure=0
insecure=0
total=0
syslog_server=""
syslog_logdir=""
pkg_company="LTRL"
pkg_suffix="lunar"
base_dir="/opt/$pkg_company$pkg_suffix"
date_suffix=$( date +%d_%m_%Y_%H_%M_%S )
work_dir="$base_dir/$date_suffix"
temp_dir="$base_dir/tmp"
temp_file="$temp_dir/temp_file"
wheel_group="wheel"
docker_group="docker"
reboot=0
verbose=0
ansible=0
functions_dir="$app_dir/functions"
modules_dir="$app_dir/modules"
private_dir="$app_dir/private"
package_uninstall="no"
country_suffix="au"
language_suffix="en_US"
osx_mdns_enable="yes"
max_super_user_id="100"
use_expr="no"
use_finger="yes"
test_os="none"
test_tag="none"
do_compose=0
do_shell=0
do_remote=0

# Disable daemons

nfsd_disable="yes"
snmpd_disable="yes"
dhcpcd_disable="yes"
dhcprd_disable="yes"
sendmail_disable="yes"
ipv6_disable="yes"
routed_disable="yes"
named_disable="yes"

# Install packages

install_rsyslog="no"

# This is the company name that will go into the security message
# Change it as required

company_name="Lateral Blast Pty Ltd"

# check_virtual_platform
#
# Check if we are running on a virtual platform
#.

check_virtual_platform () {
  virtual="Unknown"
  if [ -f "/.dockerenv" ]; then
    virtual="Docker"
  else 
    check=$( command -v dmidecode | grep dmidecode | grep -v no )
    if [ "$check" ]; then
      virtual=$( dmidecode | grep Manufacturer |head -1 | awk '{print $2}' | sed "s/,//g" )
    fi
  fi
  echo "Platform:  $virtual"
}


# check_os_release
#
# Get OS release information
#.

check_os_release () {
  echo ""
  echo "# SYSTEM INFORMATION:"
  echo ""
  os_name=$( uname )
  if [ "$os_name" = "Darwin" ]; then
    set -- $( sw_vers | awk 'BEGIN { FS="[:\t.]"; } /^ProductVersion/ && $0 != "" {print $3, $4, $5}' )
    os_version=$1.$2
    os_release=$2
    os_update=$3
    os_vendor="Apple"
  fi
  if [ "$os_name" = "Linux" ]; then
    if [ -f "/etc/redhat-release" ]; then
      os_version=$( cat /etc/redhat-release | awk '{print $3}' | cut -f1 -d. )
      if [ "$os_version" = "Enterprise" ]; then
        os_version=$( cat /etc/redhat-release | awk '{print $7}' | cut -f1 -d. )
        if [ "$os_version" = "Beta" ]; then
          os_version=$( cat /etc/redhat-release | awk '{print $6}' | cut -f1 -d. )
          os_update=$( cat /etc/redhat-release | awk '{print $6}' | cut -f2 -d. )
        else
          os_update=$( cat /etc/redhat-release | awk '{print $7}' | cut -f2 -d. )
        fi
      else
        if [ "$os_version" = "release" ]; then
          os_version=$( cat /etc/redhat-release | awk '{print $4}' | cut -f1 -d. )
          os_update=$( cat /etc/redhat-release | awk '{print $4}' | cut -f2 -d. )
        else
          os_update=$( cat /etc/redhat-release | awk '{print $3}' | cut -f2 -d. )
        fi
      fi
      os_vendor=$( cat /etc/redhat-release | awk '{print $1}' )
      linux_dist="redhat"
    else
      if [ -f "/etc/debian_version" ]; then
        if [ -f "/etc/lsb-release" ]; then
          os_version=$( grep "DISTRIB_RELEASE" /etc/lsb-release | cut -f2 -d= | cut -f1 -d. )
          os_update=$( grep "DISTRIB_RELEASE" /etc/lsb-release | cut -f2 -d= | cut -f2 -d. )
          os_vendor=$( grep "DISTRIB_ID" /etc/lsb-release | cut -f2 -d= )
        else
          if [ -f "/etc/debian_version" ]; then
            os_version=$( cut -f1 -d. /etc/debian_version )
            os_update=$( cut -f2 -d. /etc/debian_version )
            os_vendor="Debian"
          else
            os_version=$( lsb_release -r | awk '{print $2}' | cut -f1 -d. )
            os_update=$( lsb_release -r | awk '{print $2}' | cut -f2 -d. )
            os_vendor=$( lsb_release -i | awk '{print $3}' )
          fi
        fi
        linux_dist="debian"
        if [ $( echo "${os_version}" | grep "[0-9]" ) ]; then 
          if [ ! -f "/usr/sbin/sysv-rc-conf" ] && [ "$os_version" -lt 16 ]; then
            echo "Notice:    The sysv-rc-conf package may be required by this script but is not present"
          fi
        fi
        if [ ! -f "/usr/bin/bc" ]; then
          use_expr="yes"
        fi
        if [ ! -f "/usr/bin/finger" ]; then
          use_finger="no"
        fi
      else
        if [ -f "/etc/SuSE-release" ]; then
          os_version=$( grep '^VERSION' /etc/SuSe-release | awk '{print $3}' | cut -f1 -d. )
          os_update=$( grep '^VERSION' /etc/SuSe-release | awk '{print $3}' | cut -f2 -d. )
          os_vendor="SuSE"
          linux_dist="suse"
        else
          if [ -f "/etc/os-release" ]; then
            os_vendor="Amazon"
            os_version=$( grep 'CPE_NAME' /etc/os-release | cut -f2 -d: | cut -f1 -d. )
            os_update=$( grep 'CPE_NAME' /etc/os-release | cut -f2 -d: | cut -f2 -d. )
          fi
        fi
      fi
    fi
  fi
  if [ "$os_name" = "SunOS" ]; then
    os_vendor="Oracle Solaris"
    os_version=$( uname -r |cut -f2 -d"." )
    if [ "$os_version" = "11" ]; then
      os_update=$( grep Solaris /etc/release | awk '{print $3}' | cut -f2 -d. )
    fi
    if [ "$os_version" = "10" ]; then
      os_update=$( grep Solaris /etc/release | awk '{print $5}' | cut -f2 -d_ | sed 's/[A-z]//g' )
    fi
    if [ "$os_version" = "9" ]; then
      os_update=$( grep Solaris /etc/release | awk '{print $4}' | cut -f2 -d_ | sed 's/[A-z]//g' )
    fi
  fi
  if [ "$os_name" = "FreeBSD" ]; then
    os_version=$( uname -r | cut -f1 -d. )
    os_update=$( uname -r | cut -f2 -d. )
    os_vendor=$os_name
  fi
  if [ "$os_name" = "AIX" ]; then
    os_vendor="IBM"
    os_version=$( oslevel | cut -f1 -d. )
    os_update=$( oslevel | cut -f2 -d. )
  fi
  if [ "$os_name" = "VMkernel" ]; then
    os_version=$( uname -r )
    os_update=$( uname -v | awk '{print $4}' )
    os_vendor="VMware"
  fi
  if [ "$os_name" != "Linux" ] && [ "$os_name" != "SunOS" ] && [ "$os_name" != "Darwin" ] && [ "$os_name" != "FreeBSD" ] && [ "$os_name" != "AIX" ] && [ "$os_name" != "VMkernel" ]; then
    echo "OS not supported"
    exit
  fi
  os_platform=$( uname -p )
  os_machine=$( uname -m )
  check_virtual_platform
  echo "Processor: $os_platform"
  echo "Machine:   $os_machine"
  echo "Vendor:    $os_vendor"
  echo "Name:      $os_name"
  echo "Version:   $os_version"
  echo "Update:    $os_update"
}

# check_environment
#
# Do some environment checks
# Create base and temporary directory
#.

check_environment () {
  check_os_release
  if [ "$os_name" = "Darwin" ]; then
    echo ""
    echo "Checking:  If node is managed"
    managed_node=$( sudo pwpolicy -n -getglobalpolicy 2>&1 |cut -f1 -d: )
    if [ "$managed_node" = "Error" ]; then
      echo "Notice:    Node is not managed"
    else
      echo "Notice:    Node is managed"
    fi
    echo ""
  fi
  if [ "$os_name" != "VMkernel" ]; then
    if [ "$os_name" = "SunOS" ]; then
      id_check=$( id | cut -c5 )
    else
      id_check=$( id -u )
    fi
    if [ "$id_check" != "0" ]; then
      if [ "$os_name" != "Darwin" ]; then
        echo ""
        echo "Warning: $0 may need root"
        echo ""
      fi
    fi
  fi
  base_dir="$HOME/.$pkg_suffix"
  temp_dir="/tmp"
  work_dir="$base_dir/$date_suffix"
  # Load functions from functions directory
  if [ -d "$functions_dir" ]; then
    if [ "$verbose" = "1" ]; then
      echo ""
      echo "Loading Functions"
      echo ""
    fi
    for file_name in $( ls $functions_dir/*.sh ); do
      if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ] ||  [ "$os_vendor" = "Debian" ] || [ "$os_vendor" = "Ubuntu" ]; then
        . $file_name
      else
        source $file_name
      fi
      if [ "$verbose" = "1" ]; then
        echo "Loading:   $file_name"
      fi
    done
  fi
  # Load modules for modules directory
  if [ -d "$modules_dir" ]; then
    if [ "$verbose" = "1" ]; then
      echo ""
      echo "Loading Modules"
      echo ""
    fi
    for file_name in $( ls $modules_dir/*.sh ); do
      if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ] || [ "$os_vendor" = "Debian" ] || [ "$os_vendor" = "Ubuntu" ]; then
        . $file_name
      else
        if [ "$file_name" = "modules/audit_ftp_users.sh" ]; then
          if [ "$os_name" != "VMkernel" ]; then
             source $file_name
          fi
        else
          source $file_name
        fi
      fi
      if [ "$verbose" = "1" ]; then
        echo "Loading:   $file_name"
      fi
    done
  fi
  # Private modules for customers
  if [ -d "$private_dir" ]; then
      echo ""
      echo "Loading Customised Modules"
      echo ""
    if [ "$verbose" = "1" ]; then
      echo ""
    fi
    for file_name in $( ls $private_dir/*.sh ); do
      if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ] ||  [ "$os_vendor" = "Debian" ] || [ "$os_vendor" = "Ubuntu" ]; then
        . $file_name
      else
        source $file_name
      fi
    done
    if [ "$verbose" = "1" ]; then
      echo "Loading:   $file_name"
    fi
  fi
  if [ ! -d "$base_dir" ]; then
    mkdir -p $base_dir
    chmod 700 $base_dir
  fi
  if [ ! -d "$temp_dir" ]; then
    mkdir -p $temp_dir
  fi
  if [ "$audit_mode" = 0 ]; then
    if [ ! -d "$work_dir" ]; then
      mkdir -p $work_dir
    fi
  fi
}

# lockdown_command
#
# Run a lockdown command
# Check that we are in lockdown mode
# If not in lockdown mode output a verbose message
#.

lockdown_command () {
  command=$1
  message=$2
  if [ "$audit_mode" = 0 ]; then
    if [ "$message" ]; then
      echo "Setting:   $message"
    fi
    echo "Executing: $command"
   $( $command )
  else
    verbose_message "$command" fix
  fi
}

# restore_command
#
# Restore command
# Check we are running in restore mode run a command
#.

restore_command () {
  command=$1
  message=$2
  if [ "$audit_mode" = 0 ]; then
    if [ "$message" ]; then
      echo "Restoring: $message"
    fi
    echo "Executing: $command"
   $( $command )
  else
    verbose_message "$command" fix
  fi
}

#
# backup_state
#
# Backup state to a log file for later restoration
#.

backup_state () {
  if [ "$audit_mode" = 0 ]; then
    backup_name=$1
    backup_value=$1
    backup_file="$work_dir/$backup_name.log"
    echo "$backup_value" > $backup_file
  fi
}

#
# restore_state
#
# Restore state from a log file
#.

restore_state () {
  if [ "$audit_mode" = 2 ]; then
    restore_name=$1
    current_value=$2
    restore_command=$3
    restore_file="$restore_dir/$restore_name"
    if [ -f "$restore_file" ]; then
      restore_value=$( cat $restore_file )
      if [ "$current_value" != "$restore_value" ]; then
        echo "Executing: $command"
        $( $restore_command )
      fi
    fi
  fi
}

# increment_total
#
# Increment total count
#.

increment_total () {
  if [ "$audit_mode" != 2 ]; then
    total=$( expr $total + 1 )
  fi
}

# increment_secure
#
# Increment secure count
#.

increment_secure () {
  if [ "$audit_mode" != 2 ]; then
    message=$1
    total=$( expr $total + 1 )
    secure=$( expr $secure + 1 )
    echo "Secure:    $message [$secure Passes]"
  fi
}

# increment_insecure
#
# Increment insecure count
#.

increment_insecure () {
  if [ "$audit_mode" != 2 ]; then
    message=$1
    total=$( expr $total + 1 )
    insecure=$( expr $insecure + 1 )
    echo "Warning:   $message [$insecure Warnings]"
  fi
}

# print_previous
#
# Print previous changes
#.

print_previous () {
  if [ -d "$base_dir" ]; then
    echo ""
    echo "Printing previous settings:"
    echo ""
    find $base_dir -type f -print -exec cat -n {} \;
  fi
}

#
# handle_output
#
# Handle output
#.

handle_output () {
  text=$1
  echo "$1"
}

#
# setting_message
#
# Setting message
#.

setting_message () {
  verbose_message $1 setting
}

# verbose_message
#
# Print a message if verbose mode enabled
#.

verbose_message () {
  text=$1
  style=$2
  if [ "$verbose" = 1 ]; then
    if [ "$style" = "fix" ]; then
      if [ "$text" = "" ]; then
        echo ""
      else
        echo "[ Fix ]    $text"
      fi
    else
      echo "$text"
    fi
  else
    if [ ! "$style" ] && [ "$text" ]; then
      echo "Checking:  $text"
    else
      if [ "$style" = "notice" ]; then
        "Notice:    $text"
      fi
      if [ "$style" = "backup" ]; then
        "Backup:    $text"
      fi
      if [ "$style" = "setting" ]; then
        "Setting:   $text"
      fi
    fi
  fi
}


# print_changes
#
# Do a diff between previous file (saved) and existing file
#.

print_changes () {
  if [ -f "$base_dir" ]; then
    echo ""
    echo "Printing changes:"
    echo ""
    for saved_file in $( find $base_dir -type f -print ); do
      check_file=$( echo $saved_file | cut -f 5- -d"/" )
      top_dir=$( echo $saved_file | cut -f 1-4 -d"/" )
      echo "Directory: $top_dir"
      log_test=$( echo "$check_file" |grep "log$" )
      if [ $( expr "$log_test" : "[A-z]" ) = 1 ]; then
        echo "Original system parameters:"
        cat $saved_file | sed "s/,/ /g"
      else
        echo "Changes to /$check_file:"
        diff $saved_file /$check_file
      fi
    done
  else
    echo "No changes made recently"
  fi
}


# check_aws
#
# Check AWS CLI etc is installed
#.

check_aws () {
  aws_bin=$( command -v aws 2> /dev/null )
  if [ -f "$aws_bin" ]; then
    aws_creds="$HOME/.aws/credentials"
    if [ -f "$aws_creds" ]; then
      if [ "$os_name" = "Darwin" ]; then
        base64_d="base64 -D"
      else
        base64_d="base64 -d"
      fi
    else
      echo "AWS credentials file does not exit"
      exit
    fi
  else
    echo "AWS CLI is not installed"
    exit
  fi
  if [ ! "$aws_region" ]; then
    aws_region=$( aws configure get region )
  fi
}

# funct_audit_kubernetes
#
# Audit Kubernetes
#.

funct_audit_kubernetes () {
  audit_mode=$1
  check_environment
  audit_kubernetes_all
  print_results
}

# funct_audit_aws
#
# Audit AWS
#.

funct_audit_docker () {
  audit_mode=$1
  check_environment
  audit_docker_all
  print_results
}

# funct_audit_aws
#
# Audit AWS
#.

funct_audit_aws () {
  audit_mode=$1
  check_environment
  check_aws
  audit_aws_all
  print_results
}

# funct_audit_aws
#
# Audit AWS
#.

funct_audit_aws_rec () {
  audit_mode=$1
  check_environment
  check_aws
  audit_aws_rec_all
  print_results
}

# funct_audit_system
#
# Audit System
#.

funct_audit_system () {
  audit_mode=$1
  check_environment
  if [ "$audit_mode" = 0 ]; then
    if [ ! -d "$work_dir" ]; then
      mkdir -p $work_dir
      if [ "$os_name" = "SunOS" ]; then
        echo "Creating:  Alternate Boot Environment $date_suffix"
        if [ "$os_version" = "11" ]; then
          beadm create audit_$date_suffix
        fi
        if [ "$os_version" = "8" ] || [ "$os_version" = "9" ] || [ "$os_version" = "10" ]; then
          if [ "$os_platform" != "i386" ]; then
            lucreate -n audit_$date_suffix
          fi
        fi
      else
        :
        # Add code to do LVM snapshot
      fi
    fi
  fi
  if [ "$audit_mode" = 2 ]; then
    restore_dir="$base_dir/$restore_date"
    if [ ! -d "$restore_dir" ]; then
      echo "Restore directory $restore_dir does not exit"
      exit
    else
      echo "Setting:   Restore directory to $restore_dir"
    fi
  fi
  audit_system_all
  if [ "$do_fs" = 1 ]; then
    audit_search_fs
  fi
  #audit_test_subset
  if [ $( expr "$os_platform" : "sparc" ) != 1 ]; then
    audit_system_x86
  else
    audit_system_sparc
  fi
  print_results
}

# funct_audit_select
#
# Selective Audit
#.

funct_audit_select () {
  audit_mode=$1
  function=$2
  check_environment
  if [ "$( echo $function |grep aws )" ]; then
    check_aws
  fi
  if [ "$( expr $function : audit_ )" != "6" ]; then
    function="audit_$function"
  fi
  if [ "$function" != "audit_" ]; then
    print_audit_info $function
    check=$( type $function 2> /dev/null )
    if [ "$check" ]; then
      $function
    else
      echo "Warning:   Audit function $function does not exist"
      echo ""
      exit
    fi 
  fi
  print_results
}

# Get the path the script starts from

start_path=$( pwd )

# Get the version of the script from the script itself

script_version=$( cd $start_path ; cat $0 | grep '^# Version' | awk '{print $3}' )

# If given no command line arguments print usage information

if [ $( expr "$args" : "\-" ) != 1 ]; then
  print_help
  exit
fi

# apply_latest_patches
#
# Code to apply patches
# Nothing done with this yet
#.

apply_latest_patches () {
  :
}

# secure_baseline
#
# Establish a Secure Baseline
# This uses the Solaris 10 svcadm baseline
# Don't really need this so haven't coded anything for it yet
#.

secure_baseline () {
  :
}

# print_results
#
# Print Results
#.

print_results () {
  echo ""
  if [ "$audit_mode" != 1 ]; then
    if [ "$reboot" = 1 ]; then
      reboot="Required"
    else
      reboot="Not Required"
    fi
    echo "Reboot:    $reboot"
  fi
  echo "Tests:     $total"
  echo "Passes:    $secure"
  echo "Warnings:  $insecure"
  if [ "$audit_mode" = 0 ]; then
    echo "Backup:    $work_dir"
    echo "Restore:   $0 -u $date_suffix"
  fi
  echo ""
}

#
# print_tests
# Print Tests
# 

print_tests () {
  test_string="$1"
  echo ""
  if [ "$test_string" = "UNIX" ]; then
    grep_string="-v aws"
  else
    grep_string="$test_string"
  fi
  echo "$test_string Security Tests:"
  echo ""
  ls $modules_dir | grep -v '^full_' |grep -i $grep_string |sed 's/\.sh//g'
  echo ""
}

# Handle command line arguments

audit_mode=3
do_fs=3
audit_select=0
verbose=0
do_select=0
do_aws=0
do_aws_rec=0
do_docker=0

#while getopts ":abcdklpCRZe::o:r:s:t:u:z:hwADSWVLHvxn" args; do
#  case ${args} in

# print_help
#
# If given a -h or no valid switch print usage information
#.
print_help () {
  cat << EOHELP
Usage: ${0##*/} [OPTIONS...]

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

EOHELP
}

# print-usage
#
# IF given -H print some examples
#
print_usage () {
  echo ""
  echo "Examples:"
  echo ""
  echo "Run AWS CLI audit"
  echo ""
  echo "$0 -w"
  echo ""
  echo "Run Docker audit"
  echo ""
  echo "$0 -d"
  echo ""
  echo "Run in Audit Mode (for Operating Systems)"
  echo ""
  echo "$0 -a"
  echo ""
  echo "Run in Audit Mode and provide more information (for Operating Systems)"
  echo ""
  echo "$0 -a -v"
  echo ""
  echo "Display previous backups:"
  echo ""
  echo "$0 -b"
  echo "Previous backups:"
  echo "21_12_2012_19_45_05  21_12_2012_20_35_54  21_12_2012_21_57_25"
  echo ""
  echo "Restore from previous backup:"
  echo ""
  echo "$0 -u 21_12_2012_19_45_05"
  echo ""
  echo "List tests:"
  echo ""
  echo "$0 -S"
  echo ""
  echo "Only run shell based tests:"
  echo ""
  echo "$0 -s audit_shell_services"
  echo ""
}

OPTIND=1
while getopts ":aAvw:de:kxs:lLSWDRo:t:cCpZbnr:z:u:VHh" args; do
  case $args in
    a)
      audit_mode=1
      do_fs=0
      ;;
    A)
      audit_mode=1
      do_fs=1
      ;;
    w)
      audit_mode=1
      do_aws=1
      function="$OPTARG"
      ;;
    d)
      audit_mode=1
      do_docker=1
      function="$OPTARG"
      ;;
    e)
      do_remote=1
      ext_host="$OPTARG"
      ;;
    x)
      audit_mode=1
      do_aws_rec=1
      function="$OPTARG"
      ;;
    s)
      audit_mode=1
      do_fs=0
      do_select=1
      function="$OPTARG"
      ;;
    l)
      audit_mode=0
      do_fs=0
      ;;
    L)
      audit_mode=0
      do_fs=1
      ;;
    S)
      print_tests "UNIX"
      ;;
    W)
      print_tests "AWS"
      ;;
    D)
      print_tests "Docker"
      ;;  
    R)
      check_environment
      verbose=1
      module="$OPTARG"
      print_audit_info $module
      ;;
    o)
      test_os="$OPTARG"
      ;;
    t)
      test_tag="$OPTARG"
      ;;
    c)
      do_compose=1
      do_shell=0
      ;;
    C)
      do_compose=1
      do_shell=1
      ;;
    p)
      print_previous
      exit
      ;;
    Z)
      print_changes
      exit
      ;;
    b)
      echo ""
      echo "Previous backups:"
      echo ""
      ls $base_dir
      exit
      ;;
    n)
      ansible=1
      ;;
    r)
      aws_region="$OPTARG"
      ;;
    z)
      audit_mode=0
      do_fs=0
      do_select=1
      function="$OPTARG"
      ;;
    k)
      audit_mode=1
      do_kubernetes=1
      function="$OPTARG"
      ;;
    u)
      audit_mode=2
      restore_date="$OPTARG"
      ;;
    v)
      verbose=1
      ;;
    V)
      echo "$script_version"
      exit
      ;;
    H)
      print_usage
      exit
      ;;
    h)
      print_help
      if [ "$verbose" = 1 ]; then
        print_usage
      fi 
      exit 0
      ;;
    *)
      print_help >&2
      exit 1
      ;;
  esac
done
shift "$((OPTIND-1))"

if [ "$do_remote" = 1 ]; then
  echo "Copying $app_dir to $ext_host:/tmp"
  scp -r $app_dir $ext_host:/tmp
  echo "Executing lunar in audit mode (no changes will be made) on $ext_host"
  ssh $ext_host "sudo /tmp/lunar.sh -a"
  exit
fi

if [ "$do_compose" = 1 ]; then
  if [ ! "$test_os" = "none" ] && [ ! "$test_tag" = "none" ]; then
    if [ "$do_shell" = 0 ]; then
      cd $app_dir ; export OS_NAME="$test_os" ; export OS_VERSION="$test_tag" ; docker-compose run test-audit
    else
      cd $app_dir ; export OS_NAME="$test_os" ; export OS_VERSION="$test_tag" ; docker-compose run test-shell
    fi
  else
    echo "OS name or version not given"
    exit
  fi
fi 

if [ "$audit_mode" != 3 ]; then
  echo ""
  if [ "$audit_mode" = 2 ]; then
    echo "Running:   In Restore mode (changes will be made to system)"
    echo "Setting:   Restore date $restore_date"
  fi
  if [ "$audit_mode" = 1 ]; then
    echo "Running:   In audit mode (no changes will be made to system)"
  fi
  if [ "$audit_mode" = 0 ]; then
    echo "Running:   In lockdown mode (changes will be made to system)"
  fi
  if [ "$do_fs" = 1 ]; then
    echo "           Filesystem checks will be done"
  fi
  echo ""
  if [ "$do_select" = 1 ]; then
    echo "Auditing:  Selecting $function"
    funct_audit_select $audit_mode $function
  else
    if [ "$do_kubernetes" = 1 ]; then
      echo "Auditing:  Kubernetes"
      funct_audit_kubernetes $audit_mode
      exit
    fi
    if [ "$do_docker" = 1 ]; then
      echo "Auditing:  Docker"
      funct_audit_docker $audit_mode
      exit
    fi
    if [ "$do_aws" = 1 ]; then
      echo "Auditing:  AWS"
      funct_audit_aws $audit_mode
      exit
    fi
    if [ "$do_aws_rec" = 1 ]; then
      echo "Auditing:  AWS - Recommended Tests"
      funct_audit_aws_rec $audit_mode
      exit
    fi
    echo "Auditing:  OS"
    funct_audit_system $audit_mode
  fi
  exit
fi

