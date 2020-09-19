# audit_zones
#
# Turn off Zone services if zones are not being used.
#.

audit_zones () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      zone_check=$( zoneadm list -civ | awk '{print $1}' | grep 1 )
      if [ "$zone_check" != "1" ]; then
        verbose_message "Zone Daemons"
        service_name="svc:/system/rcap:default"
        check_sunos_service $service_name disabled
        service_name="svc:/system/pools:default"
        check_sunos_service $service_name disabled
        service_name="svc:/system/tsol-zones:default"
        check_sunos_service $service_name disabled
        service_name="svc:/system/zones:default"
        check_sunos_service $service_name disabled
      fi
    fi
  fi
}
