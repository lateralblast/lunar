#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# funct_audit_system
#
# Audit System
#.

funct_audit_system () {
  audit_mode=$1
  check_environment
  if [ "${audit_mode}" = 0 ]; then
    if [ ! -d "${work_dir}" ]; then
      mkdir -p "${work_dir}"
      if [ "${os_name}" = "SunOS" ]; then
        echo "Creating:  Alternate Boot Environment ${date_suffix}"
        if [ "${os_version}" = "11" ]; then
          beadm create "audit_${date_suffix}"
        fi
        if [ "${os_version}" = "8" ] || [ "${os_version}" = "9" ] || [ "${os_version}" = "10" ]; then
          if [ "${os_platform}" != "i386" ]; then
            lucreate -n "audit_${date_suffix}"
          fi
        fi
      else
        :
        # Add code to do LVM snapshot
      fi
    fi
  fi
  if [ "${audit_mode}" = 2 ]; then
    restore_dir="${base_dir}/${restore_date}"
    if [ ! -d "${restore_dir}" ]; then
      echo "Restore directory \"${restore_dir}\" does not exit"
      exit
    else
      verbose_message "Restore directory to \"${restore_dir}\"" "set"
    fi
  fi
  audit_system_all
  if [ "${do_fs}" = 1 ]; then
    audit_search_fs
  fi
  #audit_test_subset
  sparc_test=$( echo "${os_platform}" | grep -c "sparc" )
  if [ "${sparc_test}" = "0" ]; then
    audit_system_x86
  else
    audit_system_sparc
  fi
  print_results
}

# audit_system_all
#
# Audit All System
#.

audit_system_all () {
  full_audit_shell_services
  full_audit_accounting_services
  full_audit_firewall_services
  full_audit_password_services
  full_audit_kernel_services
  full_audit_mail_services
  full_audit_user_services
  full_audit_disk_services
  full_audit_hardware_services
  full_audit_power_services
  full_audit_virtualisation_services
  full_audit_x11_services
  full_audit_naming_services
  full_audit_file_services
  full_audit_web_services
  full_audit_print_services
  full_audit_routing_services
  full_audit_windows_services
  full_audit_other_daemons
  full_audit_log_services
  full_audit_network_services
  full_audit_other_services
  full_audit_update_services
  if [ "${os_name}" = "Darwin" ]; then
    full_audit_osx_services
  fi
}
