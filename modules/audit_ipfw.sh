#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ipfw
#
# Check IP Firewall
#
# Refer to Section 1.3 Page(s) 3-4 CIS FreeBSD Benchmark v1.0.5
#.

audit_ipfw () {
  print_function "audit_ipfw"
  if [ "${os_name}" = "FreeBSD" ]; then
    verbose_message  "IP Firewall"        "check"
    check_file_value "is" "/etc/rc.conf"  "firewall_enable" "eq" "YES"    "hash"
    check_file_value "is" "/etc/rc.conf"  "firewall_type"   "eq" "client" "hash"
  fi
}
