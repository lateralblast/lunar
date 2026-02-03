#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_system_auth_use_uid
#
# Check the use of su is restricted by sudo
#
# Refer to Section(s) 6.5 Page(s) 165-6 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 6.5 Page(s) 145-6 CIS RHEL 6 Benchmark v1.2.0
#.

audit_system_auth_use_uid () {
  print_function "audit_system_auth_use_uid"
  string="Check the use of su is restricted by sudo"
  check_message "${string}"
  auth_string="auth"
  search_string="use_uid"
  check_file="/etc/pam.d/su"
  temp_file="${temp_dir}/audit_system_auth_use_uid"
  if [ -f "${check_file}" ]; then
    if [ "${os_name}" = "Linux" ]; then
      if [ "${audit_mode}" != 2 ]; then
        lockdown_command="sed 's/^auth.*use_uid$/&\nauth\t\trequired\t\t\tpam_wheel.so use_uid\n/' < ${check_file} > ${temp_file} ; cat ${temp_file} > ${check_file}"
        check_value=$( grep "^${auth_string}" ${check_file} | grep "${search_string}$" | awk '{print $8}' )
        if [ "${check_value}" != "${search_string}" ]; then
          if [ "${audit_mode}" = "1" ]; then
            increment_insecure "The use of su is not restricted by sudo in ${check_file}"
            verbose_message     "${lockdown_command}" "fix"
          fi
          if [ "${audit_mode}" = 0 ]; then
            backup_file      "${check_file}"
            lockdown_message="The use of su to be restricted by sudo in ${check_file}"
            execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
          fi
        else
          if [ "${audit_mode}" = "1" ]; then
            increment_secure "The use of su is restricted by sudo in \"${check_file}\""
          fi
        fi
      else
        restore_file "${check_file}" "${restore_dir}"
      fi
    fi
  else
    na_message "${string}"
  fi
}
