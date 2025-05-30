#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_power_management
#
# Refer to Section(s) 2.12.5 Page(s) 209-210 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 10.1   Page(s) 91-2    CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 10.3   Page(s) 139     CIS Solaris 10 Benchmark v1.1.0
#.

audit_power_management () {
  print_function "audit_power_management"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "AIX" ]; then
    verbose_message "Power Management" "check"
    if [ "${os_name}" = "AIX" ]; then
      check_itab "pmd" "off"
    fi
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" = "10" ]; then
        check_file_value "is" "/etc/default/power" "PMCHANGEPERM"  "eq" "-" "hash"
        check_file_value "is" "/etc/default/power" "CPRCHANGEPERM" "eq" "-" "hash"
      fi
      if [ "${os_version}" = "11" ]; then
        poweradm_test=$( poweradm list | grep suspend | awk '{print $2}' | cut -f2 -d"=" )
        log_file="poweradm.log"
        if [ "${audit_mode}" = 2 ]; then
          restore_file="${restore_dir}/#log_file"
          if [ -f "${log_file}" ]; then
            restore_value=$( cat "${restore_file}" )
            if [ "${poweradm_test}" != "${restore_value}" ]; then
              verbose_message "Power suspend to \"${restore_value}\"" "restore"
              eval "poweradm set suspend-enable=${restore_value}"
              eval "poweradm update"
            fi
          fi
        fi
        if [ "${poweradm_test}" != "false" ]; then
          if [ "${audit_mode}" = 1 ]; then
            increment_insecure "Power suspend enabled"
            verbose_message    "poweradm set suspend-enable=false" "fix"
            verbose_message    "poweradm update"                   "fix"
          fi
          if [ "${audit_mode}" = 0 ]; then
            backup_file="${work_dir}/${log_file}"
            verbose_message "Power suspend to disabled" "set"
            echo "${poweradm_test}" > "${backup_file}"
            eval "poweradm set suspend-enable=false"
            eval "poweradm update"
          fi
        else
          if [ "${audit_mode}" = 1 ]; then
            increment_secure "Power suspend disabled"
          fi
        fi
      fi
    fi
    if [ "${os_name}" = "Linux" ]; then
      check_linux_service "apmd" "off"
    fi
  fi
}
