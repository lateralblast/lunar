#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_dhcprd
#
# Check DHCP relay
#
# Refer to Section(s) 1.3.9 Page(s) 44-5 CIS AIX Benchmark v1.1.0
#.

audit_dhcprd () {
  print_function "audit_dhcprd"
  string="DHCP Relay Daemon"
  check_message "${string}"
  if [ "${dhcprd_disable}" = "yes" ]; then
    if [ "${os_name}" = "AIX" ]; then
      check_rctcp     "dhcprd" "off"
    fi
  else
    na_message "${string}"
  fi
}
