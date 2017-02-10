# audit_dns_client
#
#.

audit_dns_client () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "Name Server Caching Daemon"
    for service_name in nscd; do
      check_chkconfig_service $service_name 3 off
      check_chkconfig_service $service_name 5 off
    done
  fi
}
