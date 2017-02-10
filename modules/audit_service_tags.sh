# audit_service_tags
#
# Turn off Service Tags if not being used. It can provide information that can
# be used as vector of attack.
#.

audit_service_tags () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message "Service Tags Daemons"
      service_name="svc:/network/stdiscover:default"
      check_sunos_service $service_name disabled
      service_name="svc:/network/stlisten:default"
      check_sunos_service $service_name disabled
      service_name="svc:/application/stosreg:default"
      check_sunos_service $service_name disabled
    fi
  fi
}
