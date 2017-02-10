# audit_echo
#
# Turn off echo and chargen services
#.

audit_echo () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message "Echo and Chargen Services"
      service_name="svc:/network/echo:dgram"
      check_sunos_service $service_name disabled
      service_name="svc:/network/echo:stream"
      check_sunos_service $service_name disabled
      service_name="svc:/network/time:dgram"
      check_sunos_service $service_name disabled
      service_name="svc:/network/time:stream"
      check_sunos_service $service_name disabled
      service_name="svc:/network/tname:default"
      check_sunos_service $service_name disabled
      service_name="svc:/network/comsat:default"
      check_sunos_service $service_name disabled
      service_name="svc:/network/discard:dgram"
      check_sunos_service $service_name disabled
      service_name="svc:/network/discard:stream"
      check_sunos_service $service_name disabled
      service_name="svc:/network/chargen:dgram"
      check_sunos_service $service_name disabled
      service_name="svc:/network/chargen:stream"
      check_sunos_service $service_name disabled
      service_name="svc:/network/rpc/spray:default"
      check_sunos_service $service_name disabled
      service_name="svc:/network/daytime:dgram"
      check_sunos_service $service_name disabled
      service_name="svc:/network/daytime:stream"
      check_sunos_service $service_name disabled
      service_name="svc:/network/talk:default"
      check_sunos_service $service_name disabled
    fi
  fi
#  if [ "$os_name" = "Linux" ]; then
#    verbose_message "Telnet and Rlogin Services"
#    for service_name in telnet login rlogin rsh shell; do
#      check_chkconfig_service $service_name 3 off
#      check_chkconfig_service $service_name 5 off
#    done
#  fi
}
