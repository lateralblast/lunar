#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_apport
#
# Check Automatic Error Reporting
#
# Refer to Section(s) 1.5.3 Page(s) 124   CIS Ubuntu 22.04 Benchmark v1.0.0
# Refer to Section(s) 1.5.5 Page(s) 181-2 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_apport () {
  print_function "audit_apport"
  string="Automatic Error Reporting"
  check_message "${string}"
  if [ "${os_vendor}" = "Ubuntu" ] && [ "${os_version}" -ge 22 ]; then
    check_file_value    "is" "/etc/default/apport"  "enabled" "eq" "0" "hash"
    check_linux_service "apport" "off"
  else
    na_message "${string}"
  fi
}
