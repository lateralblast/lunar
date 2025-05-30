#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_shells
#
# Check that shells in /etc/shells exist
#
# Refer to Section(s) 5.4.2.8-5.4.3.1,7.1.9   Page(s) 711-5,950-1   CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_shells () {
  print_function "audit_shells"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ]; then
    verbose_message "Shells" "check"
    check_file="/etc/shells"
    if [ -f "${check_file}" ]; then
      if [ "${audit_mode}" = 2 ]; then
        restore_file "${check_file}" "${restore_dir}"
      else
        check_shell="nologin" 
        nologin_check=$( grep "${check_shell}" < "${check_file}" | grep -cv "^#" )
        if [ "${nologin_check}" = "0" ]; then
          increment_secure    "Shell \"${check_shell}\" is not in \"${check_file}\""
        else
          increment_insecure  "Shell \"${check_shell}\" is in \"${check_file}\""
        fi
        check_file_comment "$check_file" "nologin" "hash"
        check_shells=$( grep -v '^#' "${check_file}" )
        for check_shell in ${check_shells}; do
          if [ ! -f "${check_shell}" ]; then
            if [ "${audit_mode}" = 1 ]; then
              increment_insecure "Shell \"${check_shell}\" in \"${check_file}\" does not exit"
            fi
            if [ "${audit_mode}" = 0 ]; then
              temp_file="${temp_dir}/shells"
              backup_file "${check_file}"
              grep -v "^${check_shell}" ${check_file} > "${temp_file}"
              cat  "${temp_file}" > "${check_file}"
            fi
          fi
        done
      fi
    fi
  fi
}
