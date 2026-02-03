#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_dhcpcd
#
# Check DHCP client
#
# Refer to Section(s) 1.3.8 Page(s) 43-4 CIS AIX Benchmark v1.1.0
#.

audit_dhcpcd () {
  print_function "audit_dhcpcd"
  string="DHCP Client Daemon"
  check_message "${string}"
  if [ "${dhcpcd_disable}" = "yes" ]; then
    if [ "${os_name}" = "AIX" ]; then
      check_rctcp     "dhcpcd" "off"
    fi
  else
    na_message "${string}"
  fi
}
