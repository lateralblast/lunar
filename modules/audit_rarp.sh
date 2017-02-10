# audit_rarp
#
# rarp: Turn off rarp if not in use
# rarp is required for jumpstart servers
#.

audit_rarp () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message "RARP Daemon"
      service_name="svc:/network/rarp:default"
      check_sunos_service $service_name disabled
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    verbose_message "RARP Daemon"
    service_name="rarpd"
    check_chkconfig_service $service_name 3 off
    check_chkconfig_service $service_name 5 off
  fi
}
