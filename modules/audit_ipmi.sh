# audit_ipmi
#
# Turn off ipmi environment daemon
#.

audit_ipmi () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "IPMI Daemons"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        service_name="svc:/network/ipmievd:default"
        check_sunos_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      for service_name in ipmi; do
        check_chkconfig_service $service_name 3 off
        check_chkconfig_service $service_name 5 off
      done
    fi
  fi
}
