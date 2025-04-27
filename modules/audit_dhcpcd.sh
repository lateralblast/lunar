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
  if [ "${dhcpcd_disable}" = "yes" ]; then
    if [ "${os_name}" = "AIX" ]; then
      verbose_message "DHCP Client Daemon" "check"
      check_rctcp     "dhcpcd" "off"
    fi
  fi
}
