#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_account_lockout
#
# Check Account Lockout
#
# Refer to Section(s) 5.18 Page(s) 66-67 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_account_lockout () {
  print_function "audit_account_lockout"
  string="Account Lockout"
  check_message "${string}"
  if [ "${os_name}" = "Darwin" ]; then
    check_pwpolicy  "maxFailedLoginAttempts"  "3"
  else
    na_message "${string}"
  fi
}
