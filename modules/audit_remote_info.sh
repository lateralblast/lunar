# audit_remote_info
#
# Turn off remote info services like rstat and finger
#
# Refer to Section(s) 1.3.16 Page(s) 52-3 CIS AIX Benchmark v1.1.0
#.

audit_remote_info () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "Remote Information Services"
    if [ "$os_name" = "AIX" ]; then
      check_rctcp rwhod off
    fi
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        service_name="svc:/network/rpc/rstat:default"
        check_sunos_service $service_name disabled
        service_name="svc:/network/nfs/rquota:default"
        check_sunos_service $service_name disabled
        service_name="svc:/network/rpc/rusers:default"
        check_sunos_service $service_name disabled
        service_name="svc:/network/finger:default"
        check_sunos_service $service_name disabled
        service_name="svc:/network/rpc/wall:default"
        check_sunos_service $service_name disabled
      fi
    fi
  fi
}
