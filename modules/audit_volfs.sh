# audit_volfs
#
# Refer to Section(s) 2.8 Page(s) 20-1 CIS Solaris 11.1 Benchmark v1.0.0
#.


audit_volfs () {
  if [ "$os_name" = "SunOS" ]; then
    verbose_message "Volume Management Daemons"
    if [ "$os_version" = "10" ]; then
      service_name="svc:/system/filesystem/volfs"
      check_sunos_service $service_name disabled
    fi
    if [ "$os_version" = "11" ]; then
      service_name="svc:/system/filesystem/rmvolmgr"
      check_sunos_service $service_name disabled
    fi
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      service_name="svc:/network/rpc/smserver"
      check_sunos_service $service_name disabled
    fi
    if [ "$os_version" = "10" ]; then
      service_name="volmgt"
      check_sunos_service $service_name disabled
    fi
  fi
}
