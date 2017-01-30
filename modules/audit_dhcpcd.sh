# audit_dhcpcd
#
# Refer to Section(s) 1.3.8 Page(s) 43-4 CIS AIX Benchmark v1.1.0
#.

audit_dhcpcd() {
  if [ "$dhcpcd_disable" = "yes" ]; then
    if [ "$os_name" = "AIX" ]; then
      funct_verbose_message "DHCP Client Daemon"
      funct_rctcp_check dhcpcd off
    fi
  fi
}
