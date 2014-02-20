# audit_dhcp_server
#
# Turn off dhcp server
#.

audit_dhcp_server () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "DHCP Server"
      service_name="svc:/network/dhcp-server:default"
      funct_service $service_name disabled
    fi
  fi
}
