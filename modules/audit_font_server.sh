# audit_font_server
#
# Turn off font server
#.

audit_font_server () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "Font Server"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        service_name="svc:/application/x11/xfs:default"
        check_sunos_service $service_name disabled
        service_name="svc:/application/font/stfsloader:default"
        check_sunos_service $service_name disabled
        service_name="svc:/application/font/fc-cache:default"
        check_sunos_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      for service_name in xfs; do
        check_chkconfig_service $service_name 3 off
        check_chkconfig_service $service_name 5 off
      done
    fi
  fi
}
