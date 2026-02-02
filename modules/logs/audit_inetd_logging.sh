#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_inetd_logging
#
# Check inetd logging
#
# Refer to Section(s) 4.1 Page(s) 66-7 CIS Solaris 10 Benchmark v5.1.0
#.

audit_inetd_logging () {
  print_function "audit_inetd_logging"
  string="Logging for inetd"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ]; then
    check_file_value "is" "/etc/default/syslogd"    "LOG_FROM_REMOTE" "eq" "NO" "hash"
    if [ "${os_version}" = "10" ]; then
      check_command_value "inetadm" "tcp_trace"     "TRUE" "tcp"
    fi
    if [ "${os_version}" = "9" ]; then
      check_file_value    "is" "/etc/default/inetd" "ENABLE_CONNECTION_LOGGING" "eq" "YES" "hash"
    fi
  else
    na_message "${string}"
  fi
}
