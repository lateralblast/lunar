# audit_echo
#
# Turn off echo and chargen services
#.

audit_echo () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "Echo and Chargen Services"
      service_name="svc:/network/echo:dgram"
      funct_service $service_name disabled
      service_name="svc:/network/echo:stream"
      funct_service $service_name disabled
      service_name="svc:/network/time:dgram"
      funct_service $service_name disabled
      service_name="svc:/network/time:stream"
      funct_service $service_name disabled
      service_name="svc:/network/tname:default"
      funct_service $service_name disabled
      service_name="svc:/network/comsat:default"
      funct_service $service_name disabled
      service_name="svc:/network/discard:dgram"
      funct_service $service_name disabled
      service_name="svc:/network/discard:stream"
      funct_service $service_name disabled
      service_name="svc:/network/chargen:dgram"
      funct_service $service_name disabled
      service_name="svc:/network/chargen:stream"
      funct_service $service_name disabled
      service_name="svc:/network/rpc/spray:default"
      funct_service $service_name disabled
      service_name="svc:/network/daytime:dgram"
      funct_service $service_name disabled
      service_name="svc:/network/daytime:stream"
      funct_service $service_name disabled
      service_name="svc:/network/talk:default"
      funct_service $service_name disabled
    fi
  fi
#  if [ "$os_name" = "Linux" ]; then
#    funct_verbose_message "Telnet and Rlogin Services"
#    for service_name in telnet login rlogin rsh shell; do
#      funct_chkconfig_service $service_name 3 off
#      funct_chkconfig_service $service_name 5 off
#    done
#  fi
}
