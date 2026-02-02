#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_system_auth_password_hashing
#
# heck password hashing settings
#
# Refer to Section(s) 5.3.4 Page(s) 243   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 5.3.4 Page(s) 224   CIS Amazon Linux Benchmark v2.0.0
#.

audit_system_auth_password_hashing () {
  print_function "audit_system_auth_password_hashing"
  auth_string="${1}"
  search_string="${2}"
  temp_file="${temp_dir}/audit_system_auth_password_hashing"
  if [ "${os_name}" = "Linux" ]; then
    if [ "${audit_mode}" != 2 ]; then
      check_file="/etc/pam.d/common-password"
      if [ -f "${check_file}" ]; then
        verbose_message "Password minimum strength enabled in \"${check_file}\"" "check"
        command="grep \"^${auth_string}\" \"${check_file}\" | grep \"${search_string}$\" | awk '{print \$8}'"
        command_message "${command}"
        check_value=$( eval "${command}" )
        lockdown_command="sed 's/^password\ssufficient\spam_unix.so/password sufficient pam_unix.so sha512/g' < ${check_file} > ${temp_file} ; cat ${temp_file} > ${check_file} ; rm ${temp_file}"
        if [ "${check_value}" != "${search_string}" ]; then
          if [ "${audit_mode}" = "1" ]; then
            increment_insecure "Password strength settings not enabled in ${check_file}"
            verbose_message    "${lockdown_command}" "fix"
          fi
          if [ "${audit_mode}" = 0 ]; then
            backup_file      "${check_file}"
            lockdown_message="Password minimum length in \"${check_file}\""
            execute_lockdown "${lockdown_command}" "${lockdown_message}" "sudo"
          fi
        else
          if [ "${audit_mode}" = "1" ]; then
            increment_secure "Password strength settings enabled in \"${check_file}\""
          fi
        fi
      fi
    else
      restore_file="/etc/pam.d/common-password"
      restore_file "${restore_file}" "${restore_dir}"
    fi
  fi
}
