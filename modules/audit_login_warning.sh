#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_login_warning
#
# An access warning may reduce a casual attacker's tendency to target the system.
# Access warnings may also aid in the prosecution of an attacker by evincing the
# attacker's knowledge of the system's private status, acceptable use policy, and
# authorization requirements.
#
# Refer to Section(s) 5.19   Page(s) 67-8  CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(s) 5.12   Page(s) 142   CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 2.10.1 Page(s) 226-8 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_login_warning () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message    "Login message warning" "check"
    check_osx_defaults "com.apple.loginwindow" "LoginwindowText" "Authorised users only"
  fi
}
