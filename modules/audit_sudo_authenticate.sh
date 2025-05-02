#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_sudo_authenticate
#
# Check sudo authenticate
#
# Refer to Section(s) 5.2.5 Page(s) 592-3 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_sudo_authenticate () {
  if [ "${os_name}" = "Darwin" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "SunOS" ]; then
    verbose_message "Sudo authenticate" "check"
    check_file="/etc/sudoers"
    if [ -f "${check_file}" ]; then
      auth_test=$( grep "^[^#].*\!authenticate" < "${check_file}" )
      if [ -n "${auth_test}" ]; then
        increment_insecure "Re-authentication is not disabled for sudo in ${check_file}"
      else
        increment_secure "Re-authentication is disabled for sudo in ${check_file}"
      fi
      check_file_perms "${check_file}" "440" "root"       "${wheel_group}" 
    fi
    if [ -d "/etc/sudoers.d" ]; then
      file_list=$( find /etc/sudoers.d -type file )
      for check_file in ${file_list}; do
        auth_test=$( grep "^[^#].*\!authenticate" < "${check_file}" )
        if [ -n "${auth_test}" ]; then
          increment_insecure "Re-authentication is not disabled for sudo in ${check_file}"
        else
          increment_secure "Re-authentication is disabled for sudo in ${check_file}"
        fi
        check_file_perms "${check_file}" "440" "root"       "${wheel_group}" 
      done
    fi
  fi
}
