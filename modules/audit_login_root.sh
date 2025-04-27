#!/bin/sh

# -> Needs fixing

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_login_root
#
# Check root login
#
# Refer to Section(s) 5.7 Page(s) 135 CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 5.6 Page(s) 348-9 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_login_root () {
  if [ "${os_name}" = "Darwin" ]; then
    verbose_message "Root login"  "check"
    check_dscl      "/Users/root" "AuthenticationAuthority" "No such key: AuthenticationAuthority"
  fi
}
