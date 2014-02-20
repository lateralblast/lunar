# audit_zones
#
# Operating system-level virtualization is a server virtualization method
# where the kernel of an operating system allows for multiple isolated
# user-space instances, instead of just one. Such instances (often called
# containers, VEs, VPSs or jails) may look and feel like a real server,
# from the point of view of its owner.
#
# Turn off Zone services if zones are not being used.
#.

audit_zones () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      zone_check=`zoneadm list -civ |awk '{print $1}' |grep 1`
      if [ "$zone_check" != "1" ]; then
        funct_verbose_message "Zone Daemons"
        service_name="svc:/system/rcap:default"
        funct_service $service_name disabled
        service_name="svc:/system/pools:default"
        funct_service $service_name disabled
        service_name="svc:/system/tsol-zones:default"
        funct_service $service_name disabled
        service_name="svc:/system/zones:default"
        funct_service $service_name disabled
      fi
    fi
  fi
}
