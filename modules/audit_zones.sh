#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_zones
#
# Turn off Zone services if zones are not being used.
#.

audit_zones () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      zone_check=$( zoneadm list -civ | awk '{print $1}' | grep 1 )
      if [ "$zone_check" != "1" ]; then
        verbose_message     "Zone Daemons"
        check_sunos_service "svc:/system/rcap:default"       "disabled"
        check_sunos_service "svc:/system/pools:default"      "disabled"
        check_sunos_service "svc:/system/tsol-zones:default" "disabled"
        check_sunos_service "svc:/system/zones:default"      "disabled"
      fi
    fi
  fi
}
