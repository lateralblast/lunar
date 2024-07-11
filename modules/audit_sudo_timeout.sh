#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_sudo_timeout
#
# Check sudo timeout
#
# Refer to Section(s) 5.1 Page(s) 48-9  CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(s) 5.3 Page(s) 128-9 CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 5.4 Page(s) 343-5 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_sudo_timeout () {
  if [ "$os_name" = "Darwin" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "SunOS" ]; then
    verbose_message "Sudo timeout" "check"
    if [ "$os_name" = "Darwin" ] && [ "$os_version" -ge 14 ]; then
      check_file="/etc/sudoers.d/sudoers_timeout"
    else
      if [ "$os_name" = "Linux" ]; then
        check_file="/etc/sudoers.d/sudoers_timeout"
      else
        check_file="/etc/sudoers"
      fi
    fi
    check_file_value_with_position "is" "$check_file" "Defaults timestamp_timeout" "eq" "0" "hash" "after" "# Defaults specification"
    check_file_perms "$check_file" "440" "root"       "wheel" 
  fi
}
