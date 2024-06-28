#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_auto_logout
#
# Check AutoLogout
#
# Refer to Section(s) 5.11 Page(s) 57-58 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_auto_logout () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message    "Autologout" "check"
    check_osx_defaults "/Library/Preferences/.GlobalPreferences" "com.apple.autologout.AutoLogOutDelay" "0" "int"
  fi
}
