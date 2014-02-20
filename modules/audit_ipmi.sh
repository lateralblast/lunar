# audit_ipmi
#
# Turn off ipmi environment daemon
#.

audit_ipmi () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "IPMI Daemons"
      service_name="svc:/network/ipmievd:default"
      funct_service $service_name disabled
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "IPMI Daemons"
    for service_name in ipmi; do
      funct_chkconfig_service $service_name 3 off
      funct_chkconfig_service $service_name 5 off
    done
  fi
}
