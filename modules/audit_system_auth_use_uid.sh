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
  auth_string="auth"
  search_string="use_uid"
  check_file="/etc/pam.d/su"
  if [ -f "${check_file}" ]; then
    if [ "${os_name}" = "Linux" ]; then
      if [ "${audit_mode}" != 2 ]; then
        verbose_message "The use of su is restricted by sudo" "check"
        check_value=$( grep "^${auth_string}" ${check_file} | grep "${search_string}$" | awk '{print $8}' )
        if [ "${check_value}" != "${search_string}" ]; then
          if [ "${audit_mode}" = "1" ]; then
            increment_insecure "The use of su is not restricted by sudo in ${check_file}"
            verbose_message     "cp ${check_file} ${temp_file}" "fix"
            verbose_message     "sed 's/^auth.*use_uid$/&\nauth\t\trequired\t\t\tpam_wheel.so use_uid\n/' < ${temp_file} > ${check_file}" "fix"
          fi
          if [ "${audit_mode}" = 0 ]; then
            backup_file      "${check_file}"
            verbose_message  "Setting:   The use of su to be restricted by sudo in ${check_file}"
            cp "${check_file}" "${temp_file}"
            sed 's/^auth.*use_uid$/&\nauth\t\trequired\t\t\tpam_wheel.so use_uid\n/' < "${temp_file}" > "${check_file}"
            if [ -f "${temp_file}" ]; then
              rm "${temp_file}"
            fi
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
  fi
}
