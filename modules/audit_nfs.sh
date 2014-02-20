# audit_nfs
#
# Turn off NFS services
#.

audit_nfs () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "NFS Services"
      service_name="svc:/network/nfs/mapid:default"
      funct_service $service_name disabled
      service_name="svc:/network/nfs/status:default"
      funct_service $service_name disabled
      service_name="svc:/network/nfs/cbd:default"
      funct_service $service_name disabled
      service_name="svc:/network/nfs/nlockmgr:default"
      funct_service $service_name disabled
      service_name="svc:/network/nfs/client:default"
      funct_service $service_name disabled
      service_name="svc:/network/nfs/server:default"
      funct_service $service_name disabled
    fi
    if [ "$os_version" != "11" ]; then
      service_name="nfs.server"
      funct_service $service_name disabled
    fi
    check_file="/etc/system"
    funct_file_value $check_file "nfssrv:nfs_portmon" eq 1 star
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "NFS Services"
    for service_name in nfs nfslock portmap rpc; do
      funct_chkconfig_service $service_name 3 off
      funct_chkconfig_service $service_name 5 off
    done
  fi
}
