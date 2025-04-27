#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_shells
#
# Check that shells in /etc/shells exist
#.

audit_shells () {
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ]; then
    verbose_message "Shells" "check"
    check_file="/etc/shells"
    if [ -f "${check_file}" ]; then
      if [ "${audit_mode}" = 2 ]; then
        restore_file "${check_file}" "${restore_dir}"
      else
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
              cat "${temp_file}" > "${check_file}"
            fi
          fi
        done
      fi
    fi
  fi
}
