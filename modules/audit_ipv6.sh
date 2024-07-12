#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_ipv6
#
# Check IPv6
#
# Refer to Section(s) 1.3.11,22-3 Page(s) 47,60-2 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 4.4.2       Page(s) 94      CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 4.4.2       Page(s) 85-6    CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 7.3.3       Page(s) 76      CIS SLES 11 Benchmark v1.0.0
#.

audit_ipv6 () {
  if [ "$ipv6_disable" = "yes" ]; then
    verbose_message "IPv6 Autoconf Daemon" "check"
    if [ "$os_name" = "AIX" ]; then
      for service_name in autoconf6 ndpd-host ndpd-router; do
        check_rctcp "$service_name" "off"
      done
    fi
    if [ "$os_name" = "Linux" ]; then
      if [ "$disable_ipv6" = "yes" ]; then
        check_append_file "/etc/modprobe.conf" "options ipv6 \"disable=1\"" "hash"
        if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
          check_file_value "is" "/etc/sysconfig/network" "NETWORKING_IPV6" "eq" "no" "hash"
          check_file_value "is" "/etc/sysconfig/network" "IPV6INIT"        "eq" "no" "hash"
        fi
      fi
    fi
  fi
}
