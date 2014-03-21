# audit_dhcp_server
#
# The Dynamic Host Configuration Protocol (DHCP) is a service that allows
# machines to be dynamically assigned IP addresses.
# Unless a server is specifically set up to act as a DHCP server, it is
# recommended that this service be removed.
#
# Turn off dhcp server
#
# Refer to Section 3.5 Page(s) 61-62 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_dhcp_server () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "DHCP Server"
      service_name="svc:/network/dhcp-server:default"
      funct_service $service_name disabled
    fi
    if [ "$os_name" = "Linux" ]; then
      if [ "$os_vendor" = "CentOS" ]; then
        funct_linux_package uninstall dhcp
      fi
    fi
  fi
}
