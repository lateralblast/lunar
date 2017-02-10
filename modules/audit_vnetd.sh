# audit_vnetd
#
# VNET Daemon
#
# Turn off vnetd
#.

audit_vnetd () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message "VNET Daemon"
      service_name="svc:/network/vnetd/tcp:default"
      check_sunos_service $service_name disabled
    fi
  fi
}
