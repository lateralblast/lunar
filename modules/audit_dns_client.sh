# audit_dns_client
#
# Turn off Name Server Caching Daemon
#.

audit_dns_client () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "Name Server Caching Daemon"
    for service_name in nscd; do
      check_linux_service $service_name off
    done
  fi
}
