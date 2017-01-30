# audit_bootparams
#
#.

audit_bootparams () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "Bootparams Daemon"
      service_name="svc:/network/rpc/bootparams:default"
      funct_service $service_name disabled
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Bootparams Daemon"
    service_name="bootparamd"
    funct_chkconfig_service $service_name 3 off
    funct_chkconfig_service $service_name 5 off
  fi
}
