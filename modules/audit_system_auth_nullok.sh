#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_system_auth_nullok
#
# Ensure null passwords are not accepted
#
# Refer to Section(s) 5.3.3.4.1 Page(s) 664-6  CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_system_auth_nullok () {
  if [ "${os_name}" = "Linux" ]; then
    if [ "${audit_mode}" != 2 ]; then
      for check_file in /etc/pam.d/common-auth /etc/pam.d/system-auth; do
        if [ -f "${check_file}" ]; then
          verbose_message "For \"nullok\" entry in \"${check_file}\"" "check"
          check_value=0
          check_value=$( grep -v '^#' "${check_file}" | grep "nullok" | head -1 | wc -l | sed "s/ //g" )
          if [ "${check_value}" = 1 ]; then
            if [ "${audit_mode}" = "1" ]; then
              increment_insecure "Found nullok \"entry\" in \"${check_file}\""
              verbose_message    "cp ${check_file} ${temp_file}" "fix"
              verbose_message    "sed 's/ nullok//' < ${temp_file} > ${check_file}" "fix"
              verbose_message    "rm ${temp_file}" "fix"
            fi
            if [ "${audit_mode}" = 0 ]; then
              backup_file      "${check_file}"
              verbose_message  "Removing \"nullok\" entries from \"${check_file}\"" "set"
              cp "${check_file}" "${temp_file}"
              sed 's/ nullok//' < "${temp_file}" > "${check_file}"
              if [ -f "${temp_file}" ]; then
                rm "${temp_file}"
              fi
            fi
          else
            if [ "${audit_mode}" = "1" ]; then
              increment_secure "No \"nullok\" entries in \"${check_file}\""
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
