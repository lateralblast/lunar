#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_dhcpscd
#
# Check DHCP server
#
# Refer to Section(s) 1.3.10 Page(s) 45-6 CIS AIX Benchmark v1.1.0
#.

audit_dhcpsd () {
  print_function "audit_dhcpsd"
  string="DHCP Server Daemon"
  check_message "${string}"
  if [ "${dhcpsd_disable}" = "yes" ]; then
    if [ "${os_name}" = "AIX" ]; then
      check_rctcp     "dhcpsd" "off"
    fi
  else
    na_message "${string}"
  fi
}
