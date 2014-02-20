# audit_remote_info
#
# Turn off remote info services like rstat and finger
#.

audit_remote_info () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "Remote Information Services"
      service_name="svc:/network/rpc/rstat:default"
      funct_service $service_name disabled
      service_name="svc:/network/nfs/rquota:default"
      funct_service $service_name disabled
      service_name="svc:/network/rpc/rusers:default"
      funct_service $service_name disabled
      service_name="svc:/network/finger:default"
      funct_service $service_name disabled
      service_name="svc:/network/rpc/wall:default"
      funct_service $service_name disabled
    fi
  fi
}
