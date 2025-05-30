#!/bin/sh -eu

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_sudo_timestanp
#
# Check sudo timestamp
#
# Refer to Section(s) 5.5   Page(s) 346-7 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
# Refer to Section(s) 5.2.6 Page(s) 592-3 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_sudo_timestamp () {
  print_module "audit_sudo_timestamp"
  if [ "${os_name}" = "Darwin" ] || [ "${os_name}" = "Linux" ] || [ "${os_name}" = "SunOS" ]; then
    verbose_message "Sudo timestamp" "check"
    if [ "${my_id}" != "0" ] && [ "${use_sudo}" = "0" ]; then
      verbose_message "Requires sudo to check" "notice"
      return
    fi
    major_ver=$( sudo --version | head -1 | awk '{print $3}' | cut -f1 -d. )
    minor_ver=$( sudo --version | head -1 | awk '{print $3}' | cut -f2 -d. )
    check_sudo="0"
    if [ "$major_ver" -gt 1 ]; then
      check_sudo="1"
    else
      if [ "$major_ver" -eq 1 ] && [ "$minor_ver" -ge 8 ]; then
        check_sudo="1"
      fi
    fi
    if [ -d "/etc/sudoers.d" ]; then
      check_file="/etc/sudoers.d/timestamp"
    else
      check_file="/etc/sudoers"
    fi
    if [ "$check_sudo" = "1" ]; then
      check_file_value "is"  "${check_file}" "Defaults timestamp_type" "eq" "tty" "hash"
      check_file_perms "${check_file}" "440" "root" "${wheel_group}" 
    fi
  fi
}
