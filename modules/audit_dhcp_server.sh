#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_dhcp_server
#
# Check DHCP server
#
# Refer to Section(s) 3.5   Page(s) 61-2  CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.3   Page(s) 74    CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 3.5   Page(s) 64-5  CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.2.5 Page(s) 105   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 6.4   Page(s) 54-5  CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.2.5 Page(s) 97    CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.2.5 Page(s) 105   CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 2.1.3 Page(s) 234-6 CIS Ubuntu 24.04 Benchmark v1.0.0
#.

audit_dhcp_server () {
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ]; then
    verbose_message "DHCP Server" "check"
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
        check_sunos_service "svc:/network/dhcp-server:default" "disabled"
      fi
    fi
    if [ "${os_name}" = "Linux" ]; then
      check_linux_service "isc-dhcp-server"   "off"
      check_linux_service "isc-dhcp-server6"  "off"
      check_linux_service "dhcpd"             "off"
      check_linux_package "uninstall"         "dhcpd"
      check_linux_package "uninstall"         "isc-dhcp-server"
    fi
  fi
}
