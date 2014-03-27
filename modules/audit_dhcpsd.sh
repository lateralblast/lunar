# audit_dhcpscd
#
# The dhcpsd daemon is the DHCP server that serves addresses and configuration
# information to DHCP clients in the network. You must disable this service if
# the server is not a DHCP server.
#
# Refer to Section(s) 1.3.10 Page(s) 45-r CIS AIX Benchmark v1.1.0
#.

audit_dhcpsd() {
  if [ "$dhcpsd_disable" = "yes" ]; then
    funct_verbose_message "DHCP Server Daemon"
    if [ "$os_name" = "AIX" ]; then
      funct_rctcp_check dhcpsd off
    fi
  fi
}
