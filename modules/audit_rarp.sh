# audit_rarp
#
# rarp: Turn off rarp if not in use
# rarp is required for jumpstart servers
#.

audit_rarp () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "RARP Daemon"
      service_name="svc:/network/rarp:default"
      funct_service $service_name disabled
    fi
  fi
}
