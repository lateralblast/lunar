#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_sudo_perms
#
# Check sudo file permissions
#.

audit_sudo_perms () {
  print_function "audit_sudo_perms"
  string="Sudo file permissions"
  check_message "${string}"
  if [ "${os_name}" = "Darwin" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "SunOS" ]; then
    check_file="/etc/sudoers"
    if [ -f "${check_file}" ]; then
      check_file_perms "${check_file}" "440" "root" "${wheel_group}" 
    fi
    if [ -d "/etc/sudoers.d" ]; then
      file_list=$( find /etc/sudoers.d -type file )
      for check_file in ${file_list}; do
        check_file_perms "${check_file}" "440" "root" "${wheel_group}" 
      done
    fi
  else
    na_message "${string}"
  fi
}
