# audit_xen
#
# Turn off Xen services if they are not being used.
#.

audit_xen () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "Xen Daemons"
    for service_name in xend xendomains; do
      check_linux_service $service_name off
    done
  fi
}
