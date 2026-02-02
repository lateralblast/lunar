#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_system_auth_password_strength
#
# Check password minimum strength enabled
#.

audit_system_auth_password_strength () {
  print_function "audit_system_auth_password_strength"
  auth_string="${1}"
  search_string="${2}"
  temo_file="${temp_dir}/audit_system_auth_password_strength"
  if [ "${os_name}" = "Linux" ]; then
    if [ "${audit_mode}" != 2 ]; then
      for check_file in /etc/pam.d/common-auth /etc/pam.d/system-auth; do
        if [ -f "${check_file}" ]; then
          verbose_message "Password minimum strength enabled in \"${check_file}\"" "check"
          command="grep \"^${auth_string}\" \"${check_file}\" | grep \"${search_string}$\" | awk '{print \$8}'"
          command_message "${command}"
          check_value=$( eval "${command}" )
          lockdown_command="sed 's/^password.*pam_deny.so$/&\npassword\t\trequisite\t\t\tpam_passwdqc.so min=disabled,disabled,16,12,8/' < ${check_file} > ${temo_file} ; cat ${temp_file} > ${check_file} ; rm ${temp_file}" "fix"
          if [ "${check_value}" != "${search_string}" ]; then
            if [ "${audit_mode}" = "1" ]; then
              increment_insecure "Password strength settings not enabled in \"${check_file}\""
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
      done
    else
      for check_file in /etc/pam.d/common-auth /etc/pam.d/system-auth; do
        restore_file "${check_file}" "${restore_dir}"
      done
    fi
  fi
}
