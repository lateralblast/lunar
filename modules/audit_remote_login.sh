#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_remote_login
#
# Check remote login
#
# Refer to Section(s) 2.4.5   Page(s) 42-3  CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 2.3.3.5 Page(s) 100-3 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_remote_login () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message       "Remote Login"   "check"
    check_osx_systemsetup "getremotelogin" "off"
  fi
}
