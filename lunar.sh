#!/bin/sh

# Name:         lunar (Lockdown UNIX Analyse Report)
# Version:      3.6.4
# Release:      1
# License:      Open Source
# Group:        System
# Source:       N/A
# URL:          http://lateralblast.com.au/
# Distribution: Solaris, Red Hat Linux, SuSE Linux, Debian Linux,
#               Ubuntu Linux, Mac OS X
# Vendor:       UNIX
# Packager:     Richard Spindler <richard@lateralblast.com.au>
# Description:  Audit script based on various benchmarks
#               Addition improvements added
#               Writen in bourne shell so it can be run on different releases

# No warrantry is implied or given with this script
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

# Set up some global variables

args=$@
score=0
pkg_company="LTRL"
pkg_suffix="lunar"
base_dir="/opt/$pkg_company$pkg_suffix"
date_suffix=`date +%d_%m_%Y_%H_%M_%S`
work_dir="$base_dir/$date_suffix"
temp_dir="$base_dir/tmp"
temp_file="$temp_dir/temp_file"
wheel_group="wheel"
reboot=0
total=0
verbose=0
functions_dir="functions"
modules_dir="modules"
private_dir="private"
package_uninstall="no"
country_suffix="au"
osx_mdns_enable="yes"
nfsd_enable="no"

# This is the company name that will go into the securit message
# Change it as required

company_name="Lateral Blast Pty Ltd"

# print_usage
#
# If given a -h or no valid switch print usage information

print_usage () {
  echo ""
  echo "Usage: $0 [-a|c|l|h|V] [-u]"
  echo ""
  echo "-a: Run in audit mode (no changes made to system)"
  echo "-A: Run in audit mode (no changes made to system)"
  echo "    [includes filesystem checks which take some time]"
  echo "-s: Run in selective mode (only run tests you want to)"
  echo "-S: List functions available to selective mode"
  echo "-l: Run in lockdown mode (changes made to system)"
  echo "-L: Run in lockdown mode (changes made to system)"
  echo "    [includes filesystem checks which take some time]"
  echo "-d: Show changes previously made to system"
  echo "-p: Show previously versions of file"
  echo "-u: Undo lockdown (changes made to system)"
  echo "-h: Display usage"
  echo "-V: Display version"
  echo "-v: Verbose mode [used with -a and -A]"
  echo "    [Provides more information about the audit taking place]"
  echo ""
  echo "Examples:"
  echo ""
  echo "Run in Audit Mode"
  echo ""
  echo "$0 -a"
  echo ""
  echo "Run in Audit Mode and provide more information"
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
  exit
}

# check_os_release
#
# Get OS release information
#.

check_os_release () {
  echo ""
  echo "# SYSTEM INFORMATION:"
  echo ""
  os_name=`uname`
  if [ "$os_name" = "Darwin" ]; then
    set -- $(sw_vers | awk 'BEGIN { FS="[:\t.]"; } /^ProductVersion/ && $0 != "" {print $3, $4, $5}')
    os_version=$1.$2
    os_update=$3
    os_vendor="Apple"
  fi
  if [ "$os_name" = "Linux" ]; then
    if [ -f "/etc/redhat-release" ]; then
      os_version=`cat /etc/redhat-release | awk '{print $3}' |cut -f1 -d'.'`
      os_update=`cat /etc/redhat-release | awk '{print $3}' |cut -f2 -d'.'`
      os_vendor=`cat /etc/redhat-release | awk '{print $1}'`
      linux_dist="redhat"
    else
      if [ -f "/etc/debian_version" ]; then
        os_version=`lsb_release -r |awk '{print $2}' |cut -f1 -d'.'`
        os_update=`lsb_release -r |awk '{print $2}' |cut -f2 -d'.'`
        os_vendor=`lsb_release -i |awk '{print $3}'`
        linux_dist="debian"
        if [ ! -f "/usr/sbin/sysv-rc-conf" ]; then
          echo "Notice:    The sysv-rc-conf package is required by this script"
          echo "Notice:    Attempting to install"
          apt-get install sysv-rc-conf
        fi
        if [ ! -f "/usr/bin/bc" ]; then
          echo "Notice:    The bc package is required by this script"
          echo "Notice:    Attempting to install"
          apt-get install bc
        fi
        if [ ! -f "/usr/bin/finger" ]; then
          echo "Notice:    The finger package is required by this script"
          echo "Notice:    Attempting to install"
          apt-get install finger
        fi
      else
        if [ -f "/etc/SuSE-release" ]; then
          os_version=`cat /etc/SuSe-release |grep '^VERSION' |awk '{print $3}' |cut -f1 -d "."`
          os_update=`cat /etc/SuSe-release |grep '^VERSION' |awk '{print $3}' |cut -f2 -d "."`
          os_vendor="SuSE"
          linux_dist="suse"
        fi
      fi
    fi
  fi
  if [ "$os_name" = "SunOS" ]; then
    os_vendor="Oracle Solaris"
    os_version=`uname -r |cut -f2 -d"."`
    if [ "$os_version" = "11" ]; then
      os_update=`cat /etc/release |grep Solaris |awk '{print $3}' |cut -f2 -d'.'`
    fi
    if [ "$os_version" = "10" ]; then
      os_update=`cat /etc/release |grep Solaris |awk '{print $5}' |cut -f2 -d'_' |sed 's/[A-z]//g'`
    fi
    if [ "$os_version" = "9" ]; then
      os_update=`cat /etc/release |grep Solaris |awk '{print $4}' |cut -f2 -d'_' |sed 's/[A-z]//g'`
    fi
  fi
  if [ "$os_name" = "FreeBSD" ]; then
    os_version=`uname -r |cut -f1 -d "."`
    os_update=`uname -r |cut -f2 -d "."`
    os_vendor=$os_name
  fi
  if [ "$os_name" != "Linux" ] && [ "$os_name" != "SunOS" ] && [ "$os_name" != "Darwin" ] || [ "$os_name" != "FreeBSD" ]; then
    echo "OS not supported"
    exit
  fi
  os_platform=`uname -p`
  echo "Platform:  $os_vendor $os_name $os_version Update $os_update on $os_platform"
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
    echo "Checking: If node is managed"
    echo ""
    managed_node=`sudo pwpolicy -n -getglobalpolicy 2>&1 |cut -f1 -d:`
  fi
  if [ "$os_name" = "SunOS" ]; then
    id_check=`id |cut -c5`
  else
    id_check=`id -u`
  fi
  if [ "$id_check" != "0" ]; then
    if [ "$os_name" != "Darwin" ]; then
      echo ""
      echo "Stopping: $0 needs to be run as root"
      echo ""
      exit
    else
      base_dir="$HOME/.$pkg_suffix"
      temp_dir="/tmp"
      work_dir="$base_dir/$date_suffix"
    fi
  fi
  # Load functions from functions directory
  if [ -d "$functions_dir" ]; then
    if [ "$verbose" = "1" ]; then
      echo ""
      echo "Loading Functions"
      echo ""
    fi
    for file_name in `ls $functions_dir/*.sh`; do
      if [ "$os_name" = "SunOS" ]; then
        . $file_name
      else
        source $file_name
      fi
      if [ "$verbose" == "1" ]; then
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
    for file_name in `ls $modules_dir/*.sh`; do
      if [ "$os_name" = "SunOS" ]; then
        . $file_name
      else
        source $file_name
      fi
      if [ "$verbose" == "1" ]; then
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
    for file_name in `ls $private_dir/*.sh`; do
      if [ "$os_name" = "SunOS" ]; then
        . $file_name
      else
        source $file_name
      fi
    done
    if [ "$verbose" == "1" ]; then
      echo "Loading:   $file_name"
    fi
  fi
  if [ ! -d "$base_dir" ]; then
    mkdir -p $base_dir
    chmod 700 $base_dir
    if [ "$os_name" != "Darwin" ]; then
      chown root:root $base_dir
    fi
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

# print_previous
#
# Print previous changes
#.

print_previous () {
  if [ -d "$base_dir" ]; then
    find $base_dir -type f -print -exec cat -n {} \;
  fi
}

# print_changes
#
# Do a diff between previous file (saved) and existing file
#.

print_changes () {
  for saved_file in `find $base_dir -type f -print`; do
    check_file=`echo $saved_file |cut -f 5- -d"/"`
    top_dir=`echo $saved_file |cut -f 1-4 -d"/"`
    echo "Directory: $top_dir"
    log_test=`echo "$check_file" |grep "log$"`
    if [ `expr "$log_test" : "[A-z]"` = 1 ]; then
      echo "Original system parameters:"
      cat $saved_file |sed "s/,/ /g"
    else
      echo "Changes to /$check_file:"
      diff $saved_file /$check_file
    fi
  done
}

# funct_audit_system () {
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
  funct_audit_system_all
  if [ "$do_fs" = 1 ]; then
    funct_audit_search_fs
  fi
  #funct_audit_test_subset
  if [ `expr "$os_platform" : "sparc"` != 1 ]; then
    funct_audit_system_x86
  else
    funct_audit_system_sparc
  fi
  print_results
}


# Get the path the script starts from

start_path=`pwd`

# Get the version of the script from the script itself

script_version=`cd $start_path ; cat $0 | grep '^# Version' |awk '{print $3}'`

# If given no command line arguments print usage information

if [ `expr "$args" : "\-"` != 1 ]; then
  print_usage
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
  if [ "$audit_mode" = 1 ]; then
    echo "Tests:     $total"
    if test $score -lt 0; then
      score=`echo $score |sed 's/-//'`
	    score=`echo $total - $score |bc`
    fi
    echo "Score:     $score"
  fi
  if [ "$audit_mode" = 0 ]; then
    echo "Backup:    $work_dir"
    echo "Restore:   $0 -u $date_suffix"
  fi
  echo ""
}
# Handle command line arguments

while getopts abdlps:u:z:hASVL args; do
  case $args in
    a)
      if [ "$2" = "-v" ]; then
        verbose=1
      fi
      echo ""
      echo "Running:   In audit mode (no changes will be made to system)"
      echo "           Filesystem checks will not be done"
      echo ""
      audit_mode=1
      do_fs=0
      funct_audit_system $audit_mode
      exit
      ;;
    s)
      if [ "$3" = "-v" ]; then
        verbose=1
      fi
      echo ""
      echo "Running:   In audit mode (no changes will be made to system)"
      echo "           Filesystem checks will not be done"
      echo ""
      audit_mode=1
      do_fs=0
      function="$OPTARG"
      echo "Auditing:  Selecting $function"
      funct_audit_select $audit_mode $function
      exit
      ;;
    z)
      if [ "$3" = "-v" ]; then
        verbose=1
      fi
      echo ""
      echo "Running:   In lockdown mode (no changes will be made to system)"
      echo "           Filesystem checks will not be done"
      echo ""
      audit_mode=0
      do_fs=0
      function="$OPTARG"
      echo "Auditing:  Selecting $function"
      funct_audit_select $audit_mode $function
      exit
      ;;
    S)
      echo ""
      echo "Functions:"
      echo ""
      cat $0 |grep 'audit_' |grep '()' | awk '{print $1}' |grep -v cat |sed 's/audit_//g' |sort
      ;;
    A)
      if [ "$2" = "-v" ]; then
        verbose=1
      fi
      echo ""
      echo "Running:   In audit mode (no changes will be made to system)"
      echo "           Filesystem checks will be done"
      echo ""
      audit_mode=1
      do_fs=1
      funct_audit_system $audit_mode
      exit
      ;;
    l)
      if [ "$2" = "-v" ]; then
        verbose=1
      fi
      echo ""
      echo "Running:   In lockdown mode (changes will be made to system)"
      echo "           Filesystem checks will not be done"
      echo ""
      audit_mode=0
      do_fs=0
      funct_audit_system $audit_mode
      exit
      ;;
    L)
      if [ "$2" = "-v" ]; then
        verbose=1
      fi
      echo ""
      echo "Running:   In lockdown mode (no changes will be made to system)"
      echo "           Filesystem checks will be done"
      echo ""
      audit_mode=0
      do_fs=1
      funct_audit_system $audit_mode
      exit
      ;;
    u)
      echo ""
      echo "Running:   In Restore mode (changes will be made to system)"
      echo ""
      audit_mode=2
      restore_date="$OPTARG"
      echo "Setting:   Restore date $restore_date"
      echo ""
      funct_audit_system $audit_mode
      exit
      ;;
    h)
      print_usage
      exit
      ;;
    V)
      echo $script_version
      exit
      ;;
    p)
      echo ""
      echo "Printing previous settings:"
      echo ""
      print_previous
      exit
      ;;
    d)
      echo ""
      echo "Printing changes:"
      echo ""
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
    *)
      print_usage
      exit
      ;;
  esac
done
