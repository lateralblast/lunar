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
  auth_string="$1"
  search_string="$2"
  if [ "${os_name}" = "Linux" ]; then
    if [ "${audit_mode}" != 2 ]; then
      check_file="/etc/pam.d/common-password"
      if [ -f "${check_file}" ]; then
        verbose_message "Password minimum strength enabled in \"${check_file}\"" "check"
        check_value=$( grep "^${auth_string}" "${check_file}" | grep "${search_string}$" | awk '{print $8}' )
        if [ "${check_value}" != "${search_string}" ]; then
          if [ "${audit_mode}" = "1" ]; then
            increment_insecure "Password strength settings not enabled in ${check_file}"
            verbose_message    "cp ${check_file} ${temp_file}" "fix"
            verbose_message    "sed 's/^password\ssufficient\spam_unix.so/password sufficient pam_unix.so sha512/g' < ${temp_file} > ${check_file}" "fix"
            verbose_message    "rm ${temp_file}" "fix"
          fi
          if [ "${audit_mode}" = 0 ]; then
            backup_file      "${check_file}"
            verbose_message  "Password minimum length in \"${check_file}\"" "set"
            cp "${check_file}" "${temp_file}"
            sed 's/^password\ssufficient\spam_unix.so/password sufficient pam_unix.so sha512/g' < "${temp_file}" > "${check_file}"
            if [ -f "${temp_file}" ]; then
              rm "${temp_file}"
            fi
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
