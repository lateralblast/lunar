#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_i4ls
#
# Check License Manager
#
# Refer to Section(s) 2.12.2 Page(s) 207 CIS AIX Benchmark v1.1.0
#.

audit_i4ls () {
  if [ "$os_name" = "AIX" ]; then
    verbose_message "License Manager" "check"
    check_itab      "i4ls" "off"
  fi
}
