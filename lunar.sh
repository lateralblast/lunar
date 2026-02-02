#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2029
# shellcheck disable=SC2034
# shellcheck disable=SC2124
# shellcheck disable=SC3046

# Name:         lunar (Lockdown UNix Auditing and Reporting)
# Version:      12.5.8
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

# Azure
azure_auth_mode="login"

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

# Defaults for SSH

ssh_protocol="2"
ssh_key_size="4096"
ssh_allowusers=""
ssh_allowgroups=""
ssh_denyusers=""
ssh_denygroups=""

# Set up some counters

secure_count=0
insecure_count=0
lockdown_count=0
restore_count=0
total_count=0

# Set up some global variables/defaults

app_dir=$( dirname "$0" )
args="$@"
use_sudo=0
syslog_server=""
syslog_logdir=""
pkg_suffix="lunar"
base_dir="/var/log/${pkg_suffix}"
temp_dir="${base_dir}/tmp"
date_suffix=$( date +%d_%m_%Y_%H_%M_%S )
temp_file="${temp_dir}/${pkg_suffix}.tmp"
work_dir="${base_dir}/${date_suffix}"
csv_dir="${base_dir}/csv"
wheel_group="wheel"
docker_group="docker"
reboot_required=0
verbose_mode=0
command_mode=0
dryrun_mode=0
ansible_mode=0
ansible_counter=0
core_dir="${app_dir}/core"
functions_dir="${app_dir}/functions"
modules_dir="${app_dir}/modules"
private_dir="${app_dir}/private"
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
do_audit=0
do_fs=0
audit_mode=1
audit_type="local"
git_url="https://github.com/lateralblast/lunar.git"
password_hashing="sha512"
anacron_enable="no"
ssh_sandbox="yes"
do_debug=0
do_select=0
module_name=""
no_cat=1
ubuntu_codename=""
output_type="cli"
output_file=""
output_csv="Module,Check,Status,Fix"
check_azure=0
check_aws=0

# Disable daemons

nfsd_disable="yes"
snmpd_disable="yes"
dhcpcd_disable="yes"
dhcprd_disable="yes"
dhcpsd_disable="yes"
sendmail_disable="yes"
ipv6_disable="yes"
routed_disable="yes"
named_disable="yes"

# verbose_message
#
# Print a message if verbose mode enabled
#.

verbose_message () {
  text="${1}"
  style="${2}"
  if [ "${verbose_mode}" = 1 ] && [ "${style}" = "fix" ]; then
    if [ "${text}" = "" ]; then
      echo ""
    else
      echo "[ Fix ]     ${text}"
      output_csv="${output_csv},${text}"
      if [ ! "${output_file}" = "" ]; then
        case "${output_csv}" in *"check_"*) echo "${output_csv}" >> "${output_file}";; esac
      fi
    fi
  else
    case $style in
      audit|auditing)
        echo "Auditing:   ${text}"
        ;;
      backup)
        echo "Backup:     ${text}"
        ;;
      check|checking)
        echo "Checking:   ${text}"
        output_csv="${output_csv},${text}"
        ;;
      create|creating)
        echo "Creating:   ${text}"
        ;;
      delete|deleting)
        echo "Deleting:   ${text}"
        ;;
      exec|execute|executing)
        echo "Executing:  ${text}"
        ;;
      install|installing)
        echo "Installing: ${text}"
        ;;
      load|loading)
        echo "Loading:    ${text}"
        ;;
      module)
        echo "Module:     ${text}"
        if [ ! "${output_file}" = "" ]; then
          case "${output_csv}" in *"check_"*) echo "${output_csv}" >> "${output_file}";; esac
        fi
        output_csv="${text}"
        ;;
      notice)
        echo "Notice:     ${text}"
        ;;
      remove|removing)
        echo "Removing:   ${text}"
        ;;
      run|running)
        echo "Running:    ${text}"
        ;;
      save|saving)
        echo "Saving:     ${text}"
        ;;
      set|setting)
        echo "Setting:    ${text}"
        ;;
      secure)
        echo "Secure:     ${text}"
        ;;
      update)
        echo "Updating:   ${text}"
        ;;
      warn|warning)
        echo "Warning:    ${text}"
        ;;
      na)
        echo "Notice:     ${text} is not applicable on this system"
        ;;
      *)
        if [ "${verbose_mode}" = 1 ]; then
          echo "${text}"
        fi
        ;;
    esac
  fi
}

# warning_message
#
# Warning message
#.

warning_message () {
  message="${1}"
  verbose_message "${message}" "warn"
}

# lockdown_warning
#
# Check whether to proceed
#.

lockdown_warning () {
  if [ "${dryrun_mode}" = 0 ]; then
    if [ "${force}" != 1 ]; then
      warning_message "This will alter the system"
      printf "%s" "Do you want to continue? (yes/no): "
      while read -r reply
      do
        case "${reply}" in
          yes)
            return
            ;;
          *)
            exit
            ;;
        esac
      done
    fi
  fi
}

# Get our ID

os_name=$( uname )
if [ "${os_name}" != "VMkernel" ]; then
  if [ "${os_name}" = "SunOS" ]; then
    id_check=$( id | cut -c5 )
  else
    id_check=$( id -u )
  fi
  arg_test=$(echo "$@" | grep -cE "\-h|\-V|\-\-help|\-\-version|info" )
  if [ "${arg_test}" != "1" ]; then
    if [ "${id_check}" != "0" ]; then
      verbose_message "$0 may need root" "warn"
    fi
  fi
fi

# Reset base dirs if not running as root
if [ ! "${id_check}" = 0 ]; then
  base_dir="$HOME/.${pkg_suffix}"
  temp_dir="${base_dir}/tmp"
  temp_file="${temp_dir}/${pkg_suffix}.tmp"
  work_dir="${base_dir}/${date_suffix}"
  csv_dir="${base_dir}/csv"
fi

# Load core functions from core directory
if [ -d "${core_dir}" ]; then
  if [ "${verbose_mode}" = "1" ]; then
    echo ""
    echo "Loading core functions"
    echo ""
  fi
  file_list=$( ls "${core_dir}"/*.sh )
  for file_name in ${file_list}; do
    . "${file_name}"
    if [ "${verbose_mode}" = "1" ]; then
      verbose_message "\"${file_name}\"" "load"
    fi
  done
fi

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
  if [ "${1}" -gt 1 ]; then
    shift "${1}" 
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
  x=${1%%"${3}"*}
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
    dmi_check=$( command -v dmidecode | grep dmidecode | grep -cv no )
    if [ "$dmi_check" = "1" ] && [ "${my_id}" = "0" ]; then
      virtual=$( dmidecode | grep Manufacturer |head -1 | awk '{print $2}' | sed "s/,//g" )
    else
      virtual=$( uname -p )
      if [ "${virtual}" = "unknown" ]; then
        virtual=$( uname -m )
      fi
    fi
  fi
  echo "Platform:   ${virtual}"
}

# execute_lockdown
#
# Run a lockdown command
# Check that we are in lockdown mode
# If not in lockdown mode output a verbose message
#.

execute_lockdown () {
  command="${1}"
  message="${2}"
  privilege="${3}"
  if [ "${audit_mode}" = 0 ]; then
    total_count=$((total_count+1))
    if [ "${message}" ]; then
      verbose_message "${message}" "set"
    fi
    verbose_message "${command}" "execute"
    if [ "${privilege}" = "" ]; then
      if [ "${dryrun_mode}" = 0 ]; then
        lockdown_count=$((lockdown_count+1))
        sh -c "${command}"
      fi
    else
      if [ "$my_id" = "0" ]; then
        if [ "${dryrun_mode}" = 0 ]; then
          lockdown_count=$((lockdown_count+1))
          sh -c "${command}"
        fi
      else
        if [ "${use_sudo}" = "1" ]; then
          if [ "${dryrun_mode}" = 0 ]; then
            lockdown_count=$((lockdown_count+1))
            sudo sh -c "${command}"
          fi
        fi
      fi
    fi
  else
    verbose_message "${command}" "fix"
  fi
}

# execute_restore
#
# Run restore command
# Check we are running in restore mode run a command
#.

execute_restore () {
  command="${1}"
  message="${2}"
  privilege="${3}"
  if [ "${audit_mode}" = 2 ]; then
    total_count=$((total_count+1))
    if [ "${message}" ]; then
      verbose_message "${message}" "restore"
    fi
    verbose_message "${command}" "execute"
    if [ "${privilege}" = "" ]; then
      if [ "${dryrun_mode}" = 0 ]; then
        restore_count=$((restore_count+1))
        sh -c "${command}"
      fi
    else
      if [ "$my_id" = "0" ]; then
        if [ "${dryrun_mode}" = 0 ]; then
          restore_count=$((restore_count+1))
          sh -c "${command}"
        fi
      else
        if [ "${use_sudo}" = "1" ]; then
          if [ "${dryrun_mode}" = 0 ]; then
            restore_count=$((restore_count+1))
            sudo sh -c "${command}"
          fi
        fi
      fi
    fi
  else
    verbose_message "${command}" "fix"
  fi
}

#
# backup_state
#
# Backup state to a log file for later restoration
#.

backup_state () {
  if [ "${audit_mode}" = 0 ]; then
    backup_name="${1}"
    backup_value="${1}"
    backup_file="${work_dir}/${backup_name}.log"
    echo "$backup_value" > "${backup_file}"
  fi
}

#
# restore_state
#
# Restore state from a log file
#.

restore_state () {
  if [ "${audit_mode}" = 2 ]; then
    restore_name="${1}"
    current_value="${2}"
    restore_command="${3}"
    restore_file="${restore_dir}/${restore_name}"
    if [ -f "${restore_file}" ]; then
      restore_value=$( cat "${restore_file}" )
      if [ "${current_value}" != "${restore_value}" ]; then
        echo "Executing: ${command}"
        eval "${restore_command}"
      fi
    fi
  fi
}

# increment_total
#
# Increment total count
#.

increment_total () {
  total_count=$((total_count+1))
}

# increment_secure
#
# Increment secure count
#.

increment_secure () {
  if [ "${audit_mode}" != 2 ]; then
    message="${1}"
    total_count=$((total_count+1))
    secure_count=$((secure_count+1))
    if [ "${secure_count}" = 1 ]; then
      echo "Secure:     ${message} [${secure_count} Pass]"
    else
      echo "Secure:     ${message} [${secure_count} Passes]"
    fi
    output_csv="${output_csv},PASS:${message}"
  fi
}

# increment_insecure
#
# Increment insecure count
#.

increment_insecure () {
  if [ "${audit_mode}" != 2 ]; then
    message="${1}"
    total_count=$((total_count+1))
    insecure_count=$((insecure_count+1))
    if [ "${insecure_count}" = 1 ]; then
      verbose_message "${message} [${insecure_count} Warning]" "warn"
    else
      verbose_message "${message} [${insecure_count} Warnings]" "warn"
    fi
    output_csv="${output_csv},FAIL:${message}"
  fi
  insecure_temp="${insecure_count}"
}

# Get the path the script starts from

start_path=$( pwd )

# Get the version of the script from the script itself

script_version=$( cd "${start_path}" || exit ; grep '^# Version' < "$0"| awk '{print $3}' )

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


# Handle command line arguments

audit_mode=3
do_fs=0
audit_select=0
verbose_mode=0
force=0
do_select=0
do_aws=0
do_aws_rec=0
do_docker=0
print_funct=0

# If given no command line arguments print usage information

if [ "$*" = "" ]; then
  print_help
  exit
fi

# Check environment for cloud providers

case "$*" in
  *azure*)
    check_azure_environment
    ;;
  *aws*) 
    check_aws_environment
    ;;
esac

# Parse arguments

while test $# -gt 0
do
  case $1 in
    -1|--list)                      # switch - List changes/backups
      list="${2}"
      if [ -z "$list" ]; then
        print_changes
        print_backups
        shift
        exit
      else
        case $list in
          changes)
            print_changes
            ;;
          backups)
            print_backups 
            ;;
          tests)
            print_tests "All"
            ;;
        esac
        shift 2
      fi
      exit
      ;;
    -2|--tests)                    # switch - Print tests
      tests="${2}" 
      if [ -z "${tests}" ]; then
        print_tests "All"
      else
        if [ "${tests}" = "--verbose" ]; then
          verbose_mode=1
          print_tests "All"
        else
          print_tests "${tests}"
          shift 2
        fi
      fi
      exit
      ;;
    -3|--printfunct)                # switch - Print function
      print_funct=1
      shift
      ;;
    -4|--dryrun)                    # switch - Run in dryrun mode
      dryrun_mode=1
      shift
      ;;
    -5|--commands)                  # switch - Display command that would be run
      command_mode=1
      shift
      ;;
    -6|--format)                    # switch - Outpt format/type
      output_type="${2}"
      shift 2
      ;;
    -7|--file)                      # switch - Output file
      output_file="${2}"
      shift 2
      ;;
    -8|--usesudo)                   # switch - Use sudo
      use_sudo=1
      shift
      ;;
    -9|--shellcheck)                # switch - Run shellcheck against script
      check_shellcheck
      shift
      exit
      ;;
    -0|--force)                     # switch - Force action
      force=1
      shift
      ;;
    -a|--audit)                     # switch - Run in audit mode (for Operating Systems - no changes made to system)
      audit_mode=1
      do_fs=0
      shift
      ;;
    -A|--fullaudit)                 # switch - Run in audit mode and include filesystems (for Operating Systems - no changes made to system)
      audit_mode=1
      do_fs=1
      shift
      ;;
    -b|--backups|--listbackups)     # switch - List backups
      print_backups
      shift
      exit
      ;;
    -B|--basedir)                   # switch - Set base directory
      base_dir="${2}"
      shift 2
      ;;
    -c|--codename|--distro)         # switch -  Distro/Code name (used with docker/multipass)
      test_distro="${2}"
      shift 2
      ;;
    -C|--shell)                     # switch - Run docker-compose testing suite (drops to shell in order to do more testing)
      do_compose=1
      do_shell=1
      shift
      ;;
    -d|--dockeraudit)               # switch - Run in audit mode (for Docker - no changes made to system)
      audit_mode=1
      do_docker=1
      module_name="${2}"
      shift 2
      ;;
    -D|--dockertests)               # switch - List all Docker functions available to selective mode
      print_tests "Docker"
      shift
      exit
      ;;  
    -e|--host)                      # switch - Run in audit mode on external host (for Operating Systems - no changes made to system)
      do_remote=1
      ext_host="${2}"
      shift 2
      ;;
    -E|--hash|--passwordhash)       # switch - Password hash
      password_hashing="${2}"
      shift 2
      ;;
    -f|--action)                    # switch - Action (e.g delete - used with multipass)
      action="${2}"
      case $action in
        audit)
          audit_mode=1
          do_fs=0
          ;;
        fullaudit)
          audit_mode=1
          do_fs=1
          ;;
        lockdown)
          audit_mode=0
          do_fs=0
          ;;
        undo|restore)
          audit_mode=2
          ;;
        osinfo|systeminfo)
          check_os_release
          exit
          ;;
      esac
      shift 2
      ;; 
    -F|--tempfile)                  # switch - Temporary file to use for operations
      temp_file="${2}"
      shift 2
      ;;
    -g|--giturl)                    # switch - Git URL for code to copy to container
      git_url="${2}"
      shift 2
      ;;
    -G|--wheelgroup)                # switch - Set wheel group
      wheel_group="${2}"
      shift 2
      ;;
    -h|--help)                      # switch - Display help
      print_help
      if [ "${verbose_mode}" = 1 ]; then
       print_usage
      fi 
      shift
      exit 0
      ;;
    -H|--usage)                     # switch - Display usage
      print_usage
      shift
      exit
      ;;
    -i|--anacron)                   # switch - Enable/Disable anacron
      anacron_enable="${2}"
      shift 2
      ;;
    -I|--type)                      # switch - Audit type
      audit_type="${2}"
      shift 2
      ;;
    -k|--kubeaudit)                 # switch - Run in audit mode (for Kubernetes - no changes made to system)
      audit_mode=1
      do_kubernetes=1
      module_name="${2}"
      shift 2
      ;;
    -K|--function|--test)           # switch - Do a specific function
      module_name="${2}"
      shift 2
      ;;
    -l|--lockdown)                  # switch - Run in lockdown mode (for Operating Systems - changes made to system)
      audit_mode=0
      do_fs=0
      shift
      ;;
    -L|--fulllockdown|fulllock)     # switch - Run in lockdown mode (for Operating Systems - changes made to system)
      audit_mode=0
      do_fs=1
      shift
      ;;
    -m|--machine|--vm)              # switch - Set virtualisation type
      vm_type="${2}"
      case $vm_type in
        docker)
          do_compose=1
          do_shell=0
          ;;
        multipass)
          do_multipass=1
          do_shell=0
          ;;
      esac
      shift 2
      ;;
    -M|--workdir)                   # switch - Set work directory
      work_dir="${2}"
      shift 2
      ;;
    -n|--ansible)                   # switch - Output ansible
      ansible_mode=1
      shift
      ;;
    -N|--nocat)                     # switch - Do output cat in score
      no_cat=1
      shift
      ;;
    -o|--os|--osver)                # switch - Set OS version
      test_os="${2}"
      shift 2
      ;;
    -O|--osinfo|--systeminfo)       # switch - Print OS/System information
      check_os_release
      shift
      exit
      ;;
    -p|--previous)                  # switch - Print previous audit information
      print_previous
      shift
      exit
      ;;
    -P|--sshsandbox|--sandbox)      # switch - Enable/Disabe SSH sandbox
      ssh_sandbox="${2}"
      shift 2
      ;;
    -q|--quiet|--nostrict)          # switch - Run in quiet mode
      unset eu
      shift
      ;;
    -Q|--debug)                     # switch - Run in debug mode
      do_debug=1
      set -ux
      shift
      ;;
    -r|--awsregion|--region)        # switch - Set AWS region
      aws_region="${2}"
      shift 2
      ;;
    -R|--moduleinfo|--testinfo)     # switch - Print information about a module
      module="${2}"
      print_audit_info "${module}"
      shift 2
      exit
      ;;
    -s|--select|--check)            # switch - Run in selective mode (only run tests you want to)
      audit_mode=1
      do_select=1
      module_name="${2}"
      shift 2
      ;;
    -S|--unixtests|--unix)          # switch - List UNIX tests
      print_tests "UNIX"
      shift
      exit
      ;;
    -t|--tag|--name)                # switch - Set docker tag
      test_tag="${2}"
      shift 2
      ;;
    -T|--tempdir)                   # switch - Set temp directoru
      temp_dir="${2}"
      shift 2
      ;;
    -u|--undo)                      # switch - Undo lockdown (for Operating Systems - changes made to system)
      audit_mode=2
      restore_date="${2}"
      shift 2
      ;;
    -U|--dofiles)                   # switch - Include filesystems
      do_fs=1
      shift
      ;;
    -v|--verbose)                   # switch - Run in verbose mode
      verbose_mode=1
      shift
      ;;
    -V|--version)                   # switch - Print version
      print_version
      shift
      exit
      ;;
    -w|--awsaudit)                  # switch - Run in audit mode (for AWS - no changes made to system)
      audit_mode=1
      do_aws=1
      module_name="${2}"
      shift 2
      ;;
    -W|--awstests|--aws)            # switch - List all AWS functions available to selective mode
      print_tests "AWS"
      shift
      exit
      ;;
    -x|--awsrec)                    # switch - Run in recommendations mode (for AWS - no changes made to system)
      audit_mode=1
      do_aws_rec=1
      module_name="${2}"
      shift 2
      ;;
    -X|--strict)                    # switch - Run shellcheck against script
      unset eu
      shift
      exit
      ;;
    -z)                             # switch - Run specified audit function in lockdown mode
      audit_mode=0
      do_fs=0
      do_select=1
      module_name="${2}"
      shift 2
      ;;
    -Z|--changes|--listchanges)     # switch - List changes
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

# Set Restore Directory if not set

if [ "${audit_mode}" = 2 ]; then
  restore_dir="${base_dir}/${restore_date}"
else
  if [ "${restore_dir}" = "" ]; then
    restore_dir="${work_dir}"
  fi
fi

# If running in dry run mode say so

if [ "${dryrun_mode}" = 1 ]; then
  verbose_message "Running in dryrun mode" "notice"
fi

# If we are in lockdown mode do a check whether we are in force mode and whether to proceed

if [ "${audit_mode}" = 0 ]; then
  lockdown_warning
fi

# Get function name

module_name=$(echo "${module_name}" | tr '[:upper:]' '[:lower:]' | sed "s/ /_/g" )

# check arguments

if [ "${do_audit}" = 1 ]; then
  if [ "${audit_type}" = "" ]; then
    audit_type="local"
  fi
fi

# Run script remotely 

if [ "${do_remote}" = 1 ]; then
  echo "Copying ${app_dir} to ${ext_host}:/tmp"
  scp -r "${app_dir}" "${ext_host}":/tmp
  echo "Executing lunar in audit mode (no changes will be made) on ${ext_host}"
  ssh "${ext_host}" "sudo sh -c \"${temp_dir}/lunar.sh -a\""
  exit
fi

# Check environment

check_environment

# Setup output file and directory

output_dir=$(dirname "${output_file}")
if [ ! -d "${output_dir}" ]; then
  mkdir -p "${output_dir}"
fi
if [ "${output_type}" = "csv" ] && [ "${output_file}" = "" ]; then
  output_file="${csv_dir}/lunar_${os_hostname}_${date_suffix}.csv"
fi
if [ "${output_type}" = "csv" ]; then
  verbose_message "${output_file}" "create"
  echo "${output_csv}" > "${output_file}"
fi

# Run in docker or multipass

if [ "${do_compose}" = 1 ] || [ "${do_multipass}" = 1 ]; then
  if [ "${do_multipass}" = 1 ]; then
    get_ubuntu_codename "${test_os}"
    test_os="${ubuntu_codename}"
    if [ "${test_tag}" = "none" ]; then
      if [ ! "${test_os}" = "none" ]; then
        test_tag="${pkg_suffix}-${test_os}"
      fi
    fi
  fi
  if [ ! "${test_os}" = "none" ] && [ ! "${test_tag}" = "none" ]; then
    if [ "${do_compose}" = 1 ]; then
      d_test=$(command -v docker-compose )
      if [ -n "$d_test" ]; then
        if [ "$do_shell" = 0 ]; then
          cd "${app_dir}" || exit ; export OS_NAME="${test_os}" ; export OS_VERSION="${test_tag}" ; docker-compose run test-audit
        else
          cd "${app_dir}" || exit ; export OS_NAME="${test_os}" ; export OS_VERSION="${test_tag}" ; docker-compose run test-shell
        fi
      else
        verbose_message "Command docker-compose not found" "warn"
        exit
      fi
    else
      mpackage_test=$(command -v multipass | wc -l | sed "s/ //g" )
      if [ "${mpackage_test}" = "1" ]; then
        vm_test=$(multipass list | awk '{print $1}' | grep -c "${test_tag}" )
        if [ "${vm_test}" = "1" ]; then
          if [ "${action}" = "delete" ]; then
            verbose_message "Multipass VM \"${test_tag}\" with release \"${test_os}\"" "delete"
            multipass delete "${test_tag}"
            multipass purge
          else
            if [ "${do_shell}" = 1 ] || [ "${action}" = "shell" ]; then
              multipass shell "${test_tag}"
            else
              if [ "${action}" = "refresh" ]; then
                multipass exec "${test_tag}" -- bash -c "rm -rf lunar"
                multipass exec "${test_tag}" -- bash -c "git clone ${git_url}"
              else
                mp_command="sudo lunar/lunar.sh --action ${action}"
                if [ "${do_debug}" = "1" ]; then  
                  mp_command="${mp_command} --debug"
                fi
                if [ "${do_select}" = "1" ]; then  
                  mp_command="${mp_command} --select ${module_name}"
                fi
                multipass exec "${test_tag}" -- bash -c "${mp_command}"
              fi
            fi
          fi
        else 
          if [ "${action}" = "delete" ]; then
            verbose_message "Multipass VM \"${test_tag}\" does not exist"
            exit
          else
            if [ "${action}" = "create" ]; then
              verbose_message "Multipass VM \"${test_tag}\" with release \"${test_os}\"" "create"
              multipass launch "${test_os}" --name "${test_tag}"
              multipass exec "${test_tag}" -- bash -c "git clone ${git_url}"
              exit
            fi
          fi
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
  exit
fi 

if [ "${audit_mode}" != 3 ]; then
  echo ""
  if [ "${audit_mode}" = 2 ]; then
    verbose_message "In Restore mode (changes will be made to system)" "run"
    verbose_message "Restore date ${restore_date}" "set"
  fi
  if [ "${audit_mode}" = 1 ]; then
    verbose_message "In audit mode (no changes will be made to system)" "run"
  fi
  if [ "${audit_mode}" = 0 ]; then
    verbose_message "In lockdown mode (changes will be made to system)" "run"
  fi
  if [ "${do_fs}" = 1 ]; then
    verbose_message "Filesystem checks will be done" "info"
  fi
  echo ""
  if [ "${do_select}" = 1 ]; then
    verbose_message    "Selecting ${module_name}" "audit"
    funct_audit_select "${audit_mode}" "${module_name}"
  else
    case "${audit_type}" in
      Kubernetes)
        verbose_message        "Kubernetes" "audit"
        funct_audit_kubernetes "${audit_mode}"
        exit
        ;;
      docker)
        verbose_message    "Docker" "audit"
        funct_audit_docker "${audit_mode}"
        exit
        ;;
      awsrecommended)
        verbose_message     "AWS - Recommended Tests" "audit"
        funct_audit_aws_rec "${audit_mode}"
        exit
        ;;
      aws)
        verbose_message "AWS" "audit"
        funct_audit_aws "${audit_mode}"
        exit
        ;;
      local|system|os)
        verbose_message    "Operating System" "audit"
        funct_audit_system "${audit_mode}"
        exit
        ;;
    esac
  fi
  exit
fi
