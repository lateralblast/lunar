#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_pass_req
#
# Set PASSREQ to YES in /etc/default/login to prevent users from loging on
# without a password
#.

audit_pass_req () {
  if [ "$os_name" = "SunOS" ]; then
    verbose_message  "Ensure password required" "check"
    check_file_value "is" "/etc/default/login"  "PASSREQ" "eq" "YES" "hash"
  fi
}
