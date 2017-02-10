# audit_dhcprd
#
# Refer to Section(s) 1.3.9 Page(s) 44-5 CIS AIX Benchmark v1.1.0
#.

audit_dhcprd() {
  if [ "$dhcprd_disable" = "yes" ]; then
    if [ "$os_name" = "AIX" ]; then
      verbose_message "DHCP Relay Daemon"
      check_rctcp dhcprd off
    fi
  fi
}
