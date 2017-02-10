# audit_apocd
#
# Turn off apocd
#.

audit_apocd () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message "APOC Daemons"
      service_name="svc:/network/apocd/udp:default"
      check_sunos_service $service_name disabled
    fi
  fi
}
