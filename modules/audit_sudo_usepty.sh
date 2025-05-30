#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_sudo_usepty
#
# Check sudo use_pty
#
# Refer to Section(s) 5.2.2 Page(s) 582-4 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_sudo_usepty () {
  print_module "audit_sudo_usepty"
  if [ "${os_name}" = "Darwin" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "SunOS" ]; then
    verbose_message "Sudo use_pty" "check"
    if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
      verbose_message "Requires sudo to check" "notice"
      return
    fi
    if [ -d "/etc/sudoers.d" ]; then
      check_file="/etc/sudoers.d/use_pty"
    else
      check_file="/etc/sudoers"
    fi
    check_append_file "${check_file}" "Defaults use_pty" "hash"
    check_file_perms  "${check_file}" "440" "root"       "${wheel_group}" 
  fi
}
