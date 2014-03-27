# audit_dhcpcd
#
# The dhcpcd daemon is the DHCP client that receives address and configuration
# information from the DHCP server. This must be disabled if DHCP is not used
# to serve IP address to the local system.
#
# Refer to Section(s) 1.3.8 Page(s) 43-4 CIS AIX Benchmark v1.1.0
#.

audit_dhcpcd() {
  if [ "$dhcpcd_disable" = "yes" ]; then
    funct_verbose_message "DHCP Client Daemon"
    if [ "$os_name" = "AIX" ]; then
      funct_rctcp_check dhcpcd off
    fi
  fi
}
