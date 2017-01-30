# audit_xen
#
# Turn off Xen services if they are not being used.
#.

audit_xen () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Xen Daemons"
    service_name="xend"
    funct_chkconfig_service $service_name 3 off
    funct_chkconfig_service $service_name 5 off
    service_name="xendomains"
    funct_chkconfig_service $service_name 3 off
    funct_chkconfig_service $service_name 5 off
  fi
}
