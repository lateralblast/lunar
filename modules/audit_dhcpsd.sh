# audit_dhcpscd
#
# Refer to Section(s) 1.3.10 Page(s) 45-6 CIS AIX Benchmark v1.1.0
#.

audit_dhcpsd() {
  if [ "$dhcpsd_disable" = "yes" ]; then
    if [ "$os_name" = "AIX" ]; then
      verbose_message "DHCP Server Daemon"
      check_rctcp dhcpsd off
    fi
  fi
}
