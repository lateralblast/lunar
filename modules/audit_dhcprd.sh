# audit_dhcprd
#
# Refer to Section(s) 1.3.9 Page(s) 44-5 CIS AIX Benchmark v1.1.0
#.

audit_dhcprd() {
  if [ "$dhcprd_disable" = "yes" ]; then
    if [ "$os_name" = "AIX" ]; then
      funct_verbose_message "DHCP Relay Daemon"
      funct_rctcp_check dhcprd off
    fi
  fi
}
