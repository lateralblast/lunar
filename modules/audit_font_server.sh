# audit_font_server
#
# Turn off cont server
#.

audit_font_server () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "Font Server"
      service_name="svc:/application/x11/xfs:default"
      funct_service $service_name disabled
      service_name="svc:/application/font/stfsloader:default"
      funct_service $service_name disabled
      service_name="svc:/application/font/fc-cache:default"
      funct_service $service_name disabled
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Font Server"
    for service_name in xfs; do
      funct_chkconfig_service $service_name 3 off
      funct_chkconfig_service $service_name 5 off
    done
  fi
}
