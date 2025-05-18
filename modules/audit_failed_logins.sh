#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_failed_logins
#
# Check failed logins
#
# Refer to Section(s) 4.6 Page(s) 70-1 CIS Solaris 10 Benchmark v5.1.0
#.

audit_failed_logins () {
  print_module "audit_failed_logins"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ]; then
      verbose_message  "Failed Login Attempts"   "check"
      check_file_value "is" "/etc/default/login" "SYSLOG_FAILED_LOGINS" "eq" "0"    "hash"
      check_file_value "is" "/etc/default/login" "SYSLOG"               "eq" "YES"  "hash"
      check_file_value "is" "/etc/default/su"    "SYSLOG"               "eq" "YES"  "hash"
    fi
  fi
}
