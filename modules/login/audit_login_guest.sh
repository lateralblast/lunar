#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_login_guest
#
# Refer to Section 1.4.2.7 Page(s)       CIS Apple OS X 10.6 Benchmark v1.0.0
# Refer to Section 6.1.3   Page(s) 156-7 CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section 2.12.1  Page(s) 242-5 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_login_guest () {
  print_function "audit_login_guest"
  string="Guest login"
  check_message "${string}"
  if [ "${os_name}" = "Darwin" ]; then
    check_osx_defaults_bool "/Library/Preferences/com.apple.loginwindow.plist" "GuestEnabled" "no"
    check_dscl              "/Users/Guest" "AuthenticationAuthority" ";basic;"
    check_dscl              "/Users/Guest" "passwd"    "*"
    check_dscl              "/Users/Guest" "UserShell" "/sbin/nologin"
  else
    na_message "${string}"
  fi
}
