#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_login_details
#
# Refer to Section 6.1.1  Page(s) 72-73 CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section 2.10.4 Page(s) 226-8 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_login_details () {
  print_function "audit_login_details"
  string="Login display details"
  check_message "${string}"
  if [ "${os_name}" = "Darwin" ]; then
    check_osx_defaults_bool "/Library/Preferences/com.apple.loginwindow" "SHOWFULLNAME" "yes"
  else
    na_message "${string}"
  fi
}
