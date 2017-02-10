# audit_ipfilter
#
# Turn off IP filter
#.

audit_ipfilter () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message "IP Filter"
      service_name="svc:/network/ipfilter:default"
      check_sunos_service $service_name disabled
      service_name="svc:/network/pfil:default"
      check_sunos_service $service_name disabled
    fi
  fi
}
