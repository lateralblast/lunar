#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_telnet_banner
#
# Set telnet banner
#
# Refer to Section(s) 8.5 Page(s) 71    CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 8.5 Page(s) 114-5 CIS Solaris 10 Benchmark v5.1.0
#.

audit_telnet_banner () {
  if [ "${os_name}" = "SunOS" ]; then
    verbose_message  "Telnet Banner" "check"
    check_file_value "is" "/etc/default/telnetd" "BANNER" "eq" "/etc/issue" "hash"
  fi
}
