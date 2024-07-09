#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090

# Name:         lunar (Lockdown UNix Auditing and Reporting)
# Version:      9.3.1
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

# Defaults for MacOS

keychain_sync="1"
disable_airdrop="1"
asset_cache="false"
wifi_status="2"
touchid_timeout="86400"

# Set up some global variables/defaults

app_dir=$( dirname "$0" )
args="*@"
secure=0
insecure=0
total=0
syslog_server=""
syslog_logdir=""
pkg_suffix="lunar"
def_base_dir="/var/log/$pkg_suffix"
date_suffix=$( date +%d_%m_%Y_%H_%M_%S )
def_work_dir="$def_base_dir/$date_suffix"
def_temp_dir="$def_base_dir/tmp"
def_temp_file="$def_temp_dir/$date_suffix.tmp"
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
action="none"
do_compose=0
do_multipass=0
do_shell=0
do_remote=0
my_id=$(id -u)
tcpd_allow="sshd"
ssh_protocol="2"
ssh_key_size="4096"
do_audit=0
do_fs=0
audit_mode=1
audit_type="local"

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

company_name="Insert Company Name Here"

# cidr_to_mask
#
# Convert CIDR to netmask
#.

cidr_to_mask () {
  set -- $(( 5 - ($1 / 8) )) 255 255 255 255 $(( (255 << (8 - ($1 % 8))) & 255 )) 0 0 0
  if [ "$1" -gt 1 ]; then
    shift "$1" 
  else
    shift
  fi
  echo "${1-0}"."${2-0}"."${3-0}"."${4-0}"
}

# mask_to_cidr
#
# Convert netmask to CIDR
#.

mask_to_cidr () {
  x="${1##*255.}"
  set -- 0^^^128^192^224^240^248^252^254^ $(( (${#1} - ${#x})*2 )) "${x%%.*}"
  x=${1%%"$3"*}
  echo $(( $2 + (${#x}/4) ))
}

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
    if [ "$check" ] && [ "$my_id" = "0" ]; then
      virtual=$( dmidecode | grep Manufacturer |head -1 | awk '{print $2}' | sed "s/,//g" )
    else
      virtual=$( uname -p )
    fi
  fi
  echo "Platform:   $virtual"
}


# check_os_release
#
# Get OS release information
#.

check_os_release () {
  echo ""
  echo "# SYSTEM INFORMATION:"
  echo ""
  os_codename=""
  os_minorrev=""
  os_name=$( uname )
  if [ "$os_name" = "Darwin" ]; then
    set -- $( sw_vers | awk 'BEGIN { FS="[:\t.]"; } /^ProductVersion/ && $0 != "" {print $3, $4, $5}' )
    os_release="$1.$2"
    os_version=$1
    os_update=$2
    os_minorrev=$3
    os_vendor="Apple"
    if [ "$os_update" = "" ]; then
      os_update=$( sw_vers |grep ^BuildVersion |awk '{print $2}' )
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    if [ -f "/etc/redhat-release" ]; then
      os_version=$( awk '{print $3}' < /etc/redhat-release | cut -f1 -d. )
      if [ "$os_version" = "Enterprise" ]; then
        os_version=$( awk '{print $7}' < /etc/redhat-release | cut -f1 -d. )
        if [ "$os_version" = "Beta" ]; then
          os_version=$( awk '{print $6}' < /etc/redhat-release | cut -f1 -d. )
          os_update=$( awk '{print $6}' < /etc/redhat-release | cut -f2 -d. )
        else
          os_update=$( awk '{print $7}' < /etc/redhat-release | cut -f2 -d. )
        fi
      else
        if [ "$os_version" = "release" ]; then
          os_version=$( awk '{print $4}' < /etc/redhat-release | cut -f1 -d. )
          os_update=$( awk '{print $4}' < /etc/redhat-release | cut -f2 -d. )
        else
          os_update=$( awk '{print $3}' < /etc/redhat-release | cut -f2 -d. )
        fi
      fi
      os_vendor=$( awk '{print $1}' < /etc/redhat-release )
      linux_dist="redhat"
    else
      if [ -f "/etc/debian_version" ]; then
        if [ -f "/etc/lsb-release" ]; then
          os_version=$( grep "DISTRIB_RELEASE" /etc/lsb-release | cut -f2 -d= | cut -f1 -d. )
          os_update=$( grep "DISTRIB_RELEASE" /etc/lsb-release | cut -f2 -d= | cut -f2 -d. )
          os_vendor=$( grep "DISTRIB_ID" /etc/lsb-release | cut -f2 -d= )
          os_codename=$( grep "DISTRIB_CODENAME" /etc/lsb-release | cut -f2 -d= )
          os_minorrev=$(lsb_release -d |awk '{print $3}' |cut -f3 -d. )
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
        os_test=$( echo "$os_version" | grep "[0-9]" )
        if [ -n "$os_test" ]; then 
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
  if [ "$os_name" = "Linux" ]; then
    os_platform=$( grep model < /proc/cpuinfo |tail -1 |cut -f2 -d: |sed "s/^ //g" )
  else
    if [ "$os_name" = "Darwin" ]; then
      os_platform=$( system_profiler SPHardwareDataType |grep Chip |cut -f2 -d: |sed "s/^ //g" )
    else
      os_platform=$( uname -p )
    fi
  fi
  os_machine=$( uname -m )
  check_virtual_platform
  if [ "$os_platform" = "" ]; then
    os_platform=$( uname -p )
  fi
  echo "Processor:  $os_platform"
  echo "Machine:    $os_machine"
  echo "Vendor:     $os_vendor"
  echo "Name:       $os_name"
  if [ ! "$os_release" = "" ]; then
    echo "Release:    $os_release"
  fi
  echo "Version:    $os_version"
  echo "Update:     $os_update"
  if [ ! "$os_minorrev" = "" ]; then
    echo "Minor Rev:  $os_minorrev"
  fi
  if [ ! "$os_codename" = "" ]; then
    echo "Codename:   $os_codename"
  fi
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_update" -lt 10 ]; then
      long_update="0$os_update"
    else
      long_update="$os_update"
    fi
    long_os_version="$os_version$long_update"
    #echo "XRelease:  $long_os_version"
  fi
}

# check_environment
#
# Do some environment checks
# Create base and temporary directory
#.

check_environment () {
  check_os_release
  if [ "$os_name" = "Darwin" ]; then
    verbose_message ""
    verbose_message "If node is managed" "check"
    managed_node=$( sudo pwpolicy -n -getglobalpolicy 2>&1 |cut -f1 -d: )
    if [ "$managed_node" = "Error" ]; then
      verbose_message "Node is not managed" "notice"
    else
      verbose_message "Node is managed" "notice"
    fi
    verbose_message ""
  fi
  if [ "$os_name" != "VMkernel" ]; then
    if [ "$os_name" = "SunOS" ]; then
      id_check=$( id | cut -c5 )
    else
      id_check=$( id -u )
    fi
    if [ "$id_check" != "0" ]; then
      if [ "$os_name" != "Darwin" ]; then
        verbose_message ""
        verbose_message "$0 may need root" "warn"
        verbose_message ""
      fi
    fi
  fi
  if [ "$base_dir" = "" ]; then
    if [ ! "$id_check" = "0" ]; then
      base_dir="$HOME/.$pkg_suffix"
    else
      base_dir="$def_base_dir"
    fi
  fi
  if [ "$temp_dir" = "" ]; then
    temp_dir="$base_dir/tmp"
  fi
  if [ "$temp_file" = "" ]; then
    temp_file="$temp_dir/$pkg_suffix.tmp"
  fi
  if [ "$work_dir" = "" ]; then
    work_dir="$base_dir/$date_suffix"
  fi
  # Load functions from functions directory
  if [ -d "$functions_dir" ]; then
    if [ "$verbose" = "1" ]; then
      echo ""
      echo "Loading Functions"
      echo ""
    fi
    file_list=$( ls "$functions_dir"/*.sh )
    for file_name in $file_list; do
      if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ] ||  [ "$os_vendor" = "Debian" ] || [ "$os_vendor" = "Ubuntu" ]; then
        . "$file_name"
      else
        source "$file_name"
      fi
      if [ "$verbose" = "1" ]; then
        echo "Loading:   \"$file_name\""
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
    file_list=$( ls "$modules_dir"/*.sh )
    for file_name in $file_list; do
      if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ] || [ "$os_vendor" = "Debian" ] || [ "$os_vendor" = "Ubuntu" ]; then
        . "$file_name"
      else
        if [ "$file_name" = "modules/audit_ftp_users.sh" ]; then
          if [ "$os_name" != "VMkernel" ]; then
             source "$file_name"
          fi
        else
          source "$file_name"
        fi
      fi
      if [ "$verbose" = "1" ]; then
        echo "Loading:   \"$file_name\""
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
    file_list=$( ls "$private_dir"/*.sh )
    for file_name in $file_list; do
      if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ] ||  [ "$os_vendor" = "Debian" ] || [ "$os_vendor" = "Ubuntu" ]; then
        . "$file_name"
      else
        source "$file_name"
      fi
    done
    if [ "$verbose" = "1" ]; then
      echo "Loading:   $file_name"
    fi
  fi
  if [ ! -d "$base_dir" ]; then
    mkdir -p "$base_dir"
    chmod 700 "$base_dir"
  fi
  if [ ! -d "$temp_dir" ]; then
    mkdir -p "$temp_dir"
  fi
  if [ "$audit_mode" = 0 ]; then
    if [ ! -d "$work_dir" ]; then
      mkdir -p "$work_dir"
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
  command="$1"
  message="$2"
  if [ "$audit_mode" = 0 ]; then
    if [ "$message" ]; then
      verbose_message "$message" "set"
    fi
    verbose_message "$command" "execute"
    eval "$command"
  else
    verbose_message "$command" "fix"
  fi
}

# restore_command
#
# Restore command
# Check we are running in restore mode run a command
#.

restore_command () {
  command="$1"
  message="$2"
  if [ "$audit_mode" = 0 ]; then
    if [ "$message" ]; then
      echo "Restoring: $message"
    fi
    echo "Executing: $command"
    eval "$command"
  else
    verbose_message "$command" "fix"
  fi
}

#
# backup_state
#
# Backup state to a log file for later restoration
#.

backup_state () {
  if [ "$audit_mode" = 0 ]; then
    backup_name="$1"
    backup_value="$1"
    backup_file="$work_dir/$backup_name.log"
    echo "$backup_value" > "$backup_file"
  fi
}

#
# restore_state
#
# Restore state from a log file
#.

restore_state () {
  if [ "$audit_mode" = 2 ]; then
    restore_name="$1"
    current_value="$2"
    restore_command="$3"
    restore_file="$restore_dir/$restore_name"
    if [ -f "$restore_file" ]; then
      restore_value=$( cat "$restore_file" )
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
    total=$((total+1))
  fi
}

# increment_secure
#
# Increment secure count
#.

increment_secure () {
  if [ "$audit_mode" != 2 ]; then
    message="$1"
    total=$((total+1))
    secure=$((insecure+1))
    echo "Secure:     $message [$secure Passes]"
  fi
}

# increment_insecure
#
# Increment insecure count
#.

increment_insecure () {
  if [ "$audit_mode" != 2 ]; then
    message="$1"
    total=$((total+1))
    insecure=$((insecure+1))
    verbose_message "$message [$insecure Warnings]" "warn"
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
    find "$base_dir" -type f -print -exec cat -n {} \;
  fi
}

# handle_output
#
# Handle output
#.

handle_output () {
  text="$1"
  echo "$1"
}

# checking_message
#
# Checking message
#.

checking_message () {
  verbose_message "$1" "check"
}

# setting_message
#
# Setting message
#.

setting_message () {
  verbose_message "$1" "set"
}

# verbose_message
#
# Print a message if verbose mode enabled
#.

verbose_message () {
  text="$1"
  style="$2"
  if [ "$verbose" = 1 ]; then
    if [ "$style" = "fix" ]; then
      if [ "$text" = "" ]; then
        echo ""
      else
        echo "[ Fix ]     $text"
      fi
    else
      echo "$text"
    fi
  else
    case $style in
      audit|auditing)
        echo "Auditing:   $text"
        ;;
      exec|execute|executing)
        echo "Executing:  $text"
        ;;
      notice)
        echo "Notice:     $text"
        ;;
      install|installing)
        echo "Installing: $text"
        ;;
      backup)
        echo "Backup:     $text"
        ;;
      save|saving)
        echo "Saving:     $text"
        ;;
      set|setting)
        echo "Setting:    $text"
        ;;
      run|running)
        echo "Running:    $text"
        ;;
      restore|restoring)
        echo "Restoring:  $text"
        ;;
      remove|removing)
        echo "Removing:   $text"
        ;;
      check|checking)
        echo "Checking:   $text"
        ;;
      create|creating)
        echo "Creating:   $text"
        ;;
      warn|warning)
        echo "Warning:    $text"
        ;;
      secure)
        echo "Secure:     $text"
        ;;
    esac
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
    file_list=$( find "$base_dir" -type f -print )
    for saved_file in $file_list; do
      check_file=$( echo "$saved_file" | cut -f 5- -d"/" )
      top_dir=$( echo "$saved_file" | cut -f 1-4 -d"/" )
      echo "Directory: \"$top_dir\""
      log_test=$( echo "$check_file" |grep "log$" )
      if [ -n "$log_test" ]; then
        echo "Original system parameters:"
        sed "s/,/ /g" < "$saved_file"
      else
        echo "Changes to \"/$check_file\":"
        diff "$saved_file" "/$check_file"
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
      mkdir -p "$work_dir"
      if [ "$os_name" = "SunOS" ]; then
        echo "Creating:  Alternate Boot Environment $date_suffix"
        if [ "$os_version" = "11" ]; then
          beadm create "audit_$date_suffix"
        fi
        if [ "$os_version" = "8" ] || [ "$os_version" = "9" ] || [ "$os_version" = "10" ]; then
          if [ "$os_platform" != "i386" ]; then
            lucreate -n "audit_$date_suffix"
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
      echo "Restore directory \"$restore_dir\" does not exit"
      exit
    else
      verbose_message "Restore directory to \"$restore_dir\"" "set"
    fi
  fi
  audit_system_all
  if [ "$do_fs" = 1 ]; then
    audit_search_fs
  fi
  #audit_test_subset
  sparc_test=$( echo "$os_platform" |grep "sparc" )
  if [ -z "$sparc_test" ]; then
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
  module_test=$(echo "$function" |grep aws)
  if [ -n "$module_test" ]; then
    check_aws
  fi
  suffix_test=$( echo "$function" |grep "\\.sh" )
  if [ "-n $suffix_test" ]; then
    function=$( echo "$function" |cut -f1 -d. )
  fi
  module_test=$(echo "$function" | grep "full" )
  if [ -z "$module_test" ]; then  
    if [ "$( expr "$function" : audit_ )" != "6" ]; then
      function="audit_$function"
    fi
  fi
  module_test=$(echo "$function" | grep "audit" )
  if [ -n "$module_test" ]; then
    if [ -f "$modules_dir/$function.sh" ]; then
      print_audit_info "$function"
      eval "$function"
    else
      verbose_message "Audit function \"$function\" does not exist" "warn"
      verbose_message ""
      exit
    fi 
    print_results
  else
    verbose_message "Audit function \"$function\" does not exist" "warn"
    verbose_message ""
  fi
}

# Get the path the script starts from

start_path=$( pwd )

# Get the version of the script from the script itself

script_version=$( cd "$start_path" || exit ; grep '^# Version' < "$0"| awk '{print $3}' )

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
    echo "Reboot:     $reboot"
  fi
  if [ ! "$audit_mode" = 2 ]; then
    echo "Tests:      $total"
    echo "Passes:     $secure"
    echo "Warnings:   $insecure"
  fi
  if [ "$audit_mode" = 0 ]; then
    echo "Backup:     $work_dir"
    echo "Restore:    $0 -u $date_suffix"
  fi
  echo ""
}

# print_tests
#
# Print Tests
#. 

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
  dir_list=$( ls "$modules_dir" ) 
  for dir_entry in $dir_list ; do
    if [ "$test_string" = "AWS" ]; then
      module_name=$( echo "$dir_entry" | grep -v "^full_" |grep "aws" |sed "s/\.sh//g" )
    else
      module_name=$( echo "$dir_entry" | grep -v "^full_" |grep -v "aws" |sed "s/\.sh//g" )
    fi
    if [ -n "$module_name" ]; then
      echo "$module_name"
    fi
  done
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

# print_version
#
# Print version information
#.

print_version () {
  echo "$script_version"
}

# print_help
#
# If given a -h or no valid switch print usage information
#.

print_help () {
  cat << EOHELP
Usage: ${0##*/} [OPTIONS...]

 -a | --audit        Run in audit mode (for Operating Systems - no changes made to system)
 -A | --fullaudit    Run in audit mode (for Operating Systems - no changes made to system)
                     [includes home directory and filesystem checks which take some time]
 -b | --backups      List backup files
 -B | --basedir      Base directory for work
 -c | --distro       Distro/Code name (used with docker/multipass)
 -C | --shell        Run docker-compose testing suite (drops to shell in order to do more testing)
 -e | --host         Run in audit mode on external host (for Operating Systems - no changes made to system)
 -d | --dockeraudit  Run in audit mode (for Docker - no changes made to system)
 -D | --dockertests  List all Docker functions available to selective mode
 -f | --action       Action (e.g delete - used with multipass) 
 -F | --tempfile     Temporary file to use for operations
 -h | --help         Display help
 -H | --usage        Display usage
 -k | --kubeaudit    Run in audit mode (for Kubernetes - no changes made to system)
 -l | --lockdown     Run in lockdown mode (for Operating Systems - changes made to system)
 -L | --fulllock     Run in lockdown mode (for Operating Systems - changes made to system)
                     [includes home directory and filesystem checks which take some time]
 -m | --machine      Create and run in a VM (docker/multipass)
 -M | --workdir      Set work directory
 -n | --ansible      Output ansible code segments
 -o | --name         Set docker/multipass OS or container name
 -O | --osinfo       Print OS information
 -p | --previous     Show previous versions of file
 -S | --unixtests    List all UNIX functions available to selective mode
 -r | --region       Specify AWS region
 -R | --testinfo     Print information for a specific test
 -s | --select       Run in selective mode (only run tests you want to)
 -t | --tag          Set docker tag
 -T | --tempdir      Set temp directory
 -u | --undo         Undo lockdown (for Operating Systems - changes made to system)
 -v | --verbose      Verbose mode [used with -a and -A]
                     [Provides more information about the audit taking place]
 -w | --awsaudit     Run in audit mode (for AWS - no changes made to system)
 -W | --awstests     List all AWS functions available to selective mode
 -V | --version      Display version
 -x | --awsrec       Run in recommendations mode (for AWS - no changes made to system)
 -z | --lockselect   Run specified audit function in lockdown mode
 -Z | --changes      Show changes previously made to system

EOHELP
}

# print_usage
#
# Print usage information
# If given -H print some examples
#.

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

# print_backups
#
# Print backups
#.

print_backups () {
  echo ""
  echo "Previous backups:"
  echo ""
  ls "$base_dir"
}

# If given no command line arguments print usage information

if [ "$*" = "" ]; then
  print_help
  exit
fi

while test $# -gt 0
do
  case $1 in
    -a|--audit)
      audit_mode=1
      do_fs=0
      shift
      ;;
    -A|--fullaudit)
      audit_mode=1
      do_fs=1
      shift
      ;;
    --mode)
      mode_value="$2"
      case $mode_value in
        audit)
          audit_mode=1
          ;;
        lockdown)
          audit_mode=0
          ;;
        undo|restore)
          audit_mode=2
          ;;
        *)
          audit_mode=1
          ;;
      esac
      shift 2
      ;;
    --dofiles)
      do_fs=1
      shift
      ;;
    --function|--test)
      function="$2"
      shift 2
      ;;
    --list)
      list="$2"
      case $list in
        changes)
          print_changes
          ;;
        backups)
          print_backups 
          ;;
      esac
      shift 2
      exit
      ;;
    --tests|--printtests)
      tests="$2" 
      case $tests in
        UNIX|unix)
          print_tests "UNIX"
          ;;
        AWS|aws)
          print_tests "AWS"
          ;;
        Docker|docker)
          print_tests "Docker"
          ;;
      esac
      shift 2
      ;;
    --type)
      audit_type="$2"
      shift 2
      ;;
    -b|--backups|--listbackups)
      print_backups
      shift
      exit
      ;;
    -B|--basedir)
      base_dir="$2"
      shift 2
      ;;
    -c|--codename|--distro)
      test_distro="$2"
      shift 2
      ;;
    -C|--shell)
      do_compose=1
      do_shell=1
      shift
      ;;
    -d|--dockeraudit)
      audit_mode=1
      do_docker=1
      function="$2"
      shift 2
      ;;
    -D|--dockertests)
      print_tests "Docker"
      shift
      exit
      ;;  
    -e|--host)
      do_remote=1
      ext_host="$2"
      shift 2
      ;;
    -f|--action)
      action="$2"
      shift 2
      ;; 
    -F|--tempfile)
      temp_file="$2"
      shift 2
      ;;
    -h|--help)
      print_help
      if [ "$verbose" = 1 ]; then
       print_usage
      fi 
      shift
      exit 0
      ;;
    -H|--usage)
      print_usage
      shift
      exit
      ;;
    -k|--kubeaudit)
      audit_mode=1
      do_kubernetes=1
      function="$2"
      shift 2
      ;;
    -l|--lockdown)
      audit_mode=0
      do_fs=0
      shift
      ;;
    -L|--fulllockdown|fulllock)
      audit_mode=0
      do_fs=1
      shift
      ;;
    -M|--workdir)
      work_dir="$2"
      shift 2
      ;;
    -m|--machine|--vm)
      vm_type="$2"
      case $vm_type in
        docker)
          do_compose=1
          do_shell=0
          ;;
        multipass)
          do_multipass=1
          ;;
      esac
      shift 2
      ;;
    -n|--ansible)
      ansible=1
      shift
      ;;
    -o|--os|osver)
      test_os="$2"
      shift 2
      ;;
    -O|--osinfo|--systeminfo)
      check_os_release
      shift
      exit
      ;;
    -p|--previous)
      print_previous
      shift
      exit
      ;;
    -r|--awsregion|--region)
      aws_region="$2"
      shift 2
      ;;
    -R|--moduleinfo|--testinfo)
      check_environment
      verbose=1
      module="$2"
      print_audit_info "$module"
      shift 2
      exit
      ;;
    -s)
      audit_mode=1
      do_fs=0
      do_select=1
      function="$2"
      shift 2
      ;;
    --select|--check)
      do_select=1
      function="$2"
      shift 2
      ;;
    -S|--unixtests|--unix)
      print_tests "UNIX"
      shift
      exit
      ;;
    -t|--tag|--name)
      test_tag="$2"
      shift 2
      ;;
    -T|--tempdir)
      temp_dir="$2"
      shift 2
      ;;
    -u|--undo)
      audit_mode=2
      restore_date="$2"
      shift 2
      ;;
    -v|--verbose)
      verbose=1
      shift
      ;;
    -V|--version)
      print_version
      shift
      exit
      ;;
    -w|--awsaudit)
      audit_mode=1
      do_aws=1
      function="$2"
      shift 2
      ;;
    -W|--awstests|--aws)
      print_tests "AWS"
      shift
      exit
      ;;
    -x|--awsrec)
      audit_mode=1
      do_aws_rec=1
      function="$2"
      shift 2
      ;;
    -z)
      audit_mode=0
      do_fs=0
      do_select=1
      function="$2"
      shift 2
      ;;
    -Z|--changes|--listchanges)
      print_changes
      shift
      exit
      ;;
    *)
      print_help >&2
      exit 1
      ;;
  esac
done

# check arguments

if [ "$do_audit" = 1 ]; then
  if [ "$audit_type" = "" ]; then
    audit_type="local"
  fi
fi

# Run script remotely 

if [ "$do_remote" = 1 ]; then
  echo "Copying $app_dir to $ext_host:/tmp"
  scp -r "$app_dir" "$ext_host":/tmp
  echo "Executing lunar in audit mode (no changes will be made) on $ext_host"
  ssh "$ext_host" "sudo /tmp/lunar.sh -a"
  exit
fi

# Run in docker or multipass

if [ "$do_compose" = 1 ] || [ "$do_multipass" = 1 ]; then
  if [ ! "$test_os" = "none" ] && [ ! "$test_tag" = "none" ]; then
    if [ "$do_compose" = 1 ]; then
      d_test=$(command -v docker-compose )
      if [ -n "$d_test" ]; then
        if [ "$do_shell" = 0 ]; then
          cd "$app_dir" || exit ; export OS_NAME="$test_os" ; export OS_VERSION="$test_tag" ; docker-compose run test-audit
        else
          cd "$app_dir" || exit ; export OS_NAME="$test_os" ; export OS_VERSION="$test_tag" ; docker-compose run test-shell
        fi
      else
        verbose_message "Command docker-compose not found" "warn"
        exit
      fi
    else
      mp_test=$(command -v multipass)
      if [ -n "$mp_test" ]
        vm_test=$(multipass list |awk '{print $1}' |grep "$test_tag" )
        if [ -n "$vm_test" ]; then
          if [ "$action" = "delete" ]; then
            multipass delete "$test_tag"
            multipass purge
          else
            if [ "$do_shell" = 0 ]; then
            else
            fi
          fi
        else 
          if [ "$action" = "delete" ]; then
            verbose_message "Multipass VM \"$test_tag\" does not exist"
            exit
          else
            multipass launch "$test_os" --name "$test_tag"
          fi
        fi
        if [ "$do_shell" = 0 ]; then
          ;;
        else
          ;;
        fi
      else
        verbose_message "Command multipass not found" "warn"
        exit
      fi
    fi
  else
    echo "OS name or version not given"
    exit
  fi
fi 

if [ "$audit_mode" != 3 ]; then
  echo ""
  if [ "$audit_mode" = 2 ]; then
    verbose_message "In Restore mode (changes will be made to system)" "run"
    verbose_message "Restore date $restore_date" "set"
  fi
  if [ "$audit_mode" = 1 ]; then
    verbose_message "In audit mode (no changes will be made to system)" "run"
  fi
  if [ "$audit_mode" = 0 ]; then
    verbose_message "In lockdown mode (changes will be made to system)" "run"
  fi
  if [ "$do_fs" = 1 ]; then
    verbose_message "Filesystem checks will be done" "info"
  fi
  echo ""
  if [ "$do_select" = 1 ]; then
    verbose_message    "Selecting $function" "audit"
    funct_audit_select "$audit_mode" "$function"
  else
    case $audit_type in
      Kubernetes)
        verbose_message        "Kubernetes" "audit"
        funct_audit_kubernetes "$audit_mode"
        exit
        ;;
      docker)
        verbose_message    "Docker" "audit"
        funct_audit_docker "$audit_mode"
        exit
        ;;
      awsrecommended)
        verbose_message     "AWS - Recommended Tests" "audit"
        funct_audit_aws_rec "$audit_mode"
        exit
        ;;
      aws)
        verbose_message "AWS" "audit"
        funct_audit_aws "$audit_mode"
        exit
        ;;
      local|system|os)
        verbose_message    "Operating System" "audit"
        funct_audit_system "$audit_mode"
        exit
        ;;
    esac
  fi
  exit
fi
