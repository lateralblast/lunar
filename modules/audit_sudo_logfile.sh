#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_sudo_logfile
#
# Check sudo logfile
#
# Refer to Section(s) 5.2.3 Page(s) 585-7 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_sudo_logfile () {
  if [ "${os_name}" = "Darwin" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "SunOS" ]; then
    verbose_message "Sudo logfile" "check"
    check_file="/etc/sudoers"
    if [ -f "${check_file}" ]; then
      check_file_value_with_position   "is"  "${check_file}" "Defaults logfile" "eq" "/var/log/sudo.log" "hash" "after" "# Defaults specification"
      check_file_perms "${check_file}" "440" "root"          "${wheel_group}" 
    fi
  fi
}
