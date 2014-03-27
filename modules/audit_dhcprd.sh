# audit_dhcprd
#
# The dhcprd daemon is the DHCP relay deamon that forwards the DHCP and BOOTP
# packets in the network. You must disable this service if DHCP is not enabled
# in the network.
#
# Refer to Section(s) 1.3.9 Page(s) 44-5 CIS AIX Benchmark v1.1.0
#.

audit_dhcprd() {
  if [ "$dhcprd_disable" = "yes" ]; then
    funct_verbose_message "DHCP Relay Daemon"
    if [ "$os_name" = "AIX" ]; then
      funct_rctcp_check dhcprd off
    fi
  fi
}
