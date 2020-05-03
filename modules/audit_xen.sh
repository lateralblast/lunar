# audit_xen
#
# Turn off Xen services if they are not being used.
#.

audit_xen () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "Xen Daemons"
    for service_name in xend xendomains; do
      check_chkconfig_service $service_name 3 off
      check_chkconfig_service $service_name 5 off
    done
  fi
}
