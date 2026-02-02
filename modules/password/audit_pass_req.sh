#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_pass_req
#
# Set PASSREQ to YES in /etc/default/login to prevent users from loging on
# without a password
#.

audit_pass_req () {
  print_function "audit_pass_req"
  string="Password Required"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ]; then
    check_file_value "is" "/etc/default/login"  "PASSREQ" "eq" "YES" "hash"
  else
    na_message "${string}"
  fi
}
