# audit_dhcp_server
#
# Refer to Section(s) 3.5   Page(s) 61-2 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.3   Page(s) 74   CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 3.5   Page(s) 64-5 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.2.5 Page(s) 105  CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 6.4   Page(s) 54-5 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 2.2.5 Page(s) 97   CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.2.5 Page(s) 105  CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_dhcp_server () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "DHCP Server"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        service_name="svc:/network/dhcp-server:default"
        check_sunos_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      check_systemctl_service disable dhcpd
      check_linux_package uninstall dhcp
    fi
  fi
}
