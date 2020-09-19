# audit_nfs
#
# Refer to Section(s) 3.8    Page(s) 64-5  CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.8    Page(s) 77    CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 3.8    Page(s) 67-8  CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 2.2.7  Page(s) 107   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 6.7    Page(s) 57-8  CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 3.7-11 Page(s) 11-3  CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.3.5  Page(s) 39    CIS AIX Benchmark v1.1.0
# Refer to Section(s) 2.2.7  Page(s) 99    CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 2.2.7  Page(s) 107   CIS Ubuntu 16.04 Benchmark v1.0.0
# Refer to Section(s) 4.6    Page(s) 105-6 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_nfs () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ] || [ "$os_name" = "Darwin" ]; then
    if [ "$nfsd_disable" = "yes" ]; then
      verbose_message "NFS Services"
      if [ "$os_name" = "AIX" ]; then
        check_itab rcnfs off
      fi
      if [ "$os_name" = "Darwin" ]; then
        check=$( ps -ef | grep nfsd | grep -v grep )
        if [ "$check" ]; then
          increment_insecure "NFS daemon enabled"
        else
          increment_secure "NFS daemon disabled"
        fi
      fi
      if [ "$os_name" = "SunOS" ]; then
        if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
          service_name="svc:/network/nfs/mapid:default"
          check_sunos_service $service_name disabled
          service_name="svc:/network/nfs/status:default"
          check_sunos_service $service_name disabled
          service_name="svc:/network/nfs/cbd:default"
          check_sunos_service $service_name disabled
          service_name="svc:/network/nfs/nlockmgr:default"
          check_sunos_service $service_name disabled
          service_name="svc:/network/nfs/client:default"
          check_sunos_service $service_name disabled
          service_name="svc:/network/nfs/server:default"
          check_sunos_service $service_name disabled
        fi
        if [ "$os_version" != "11" ]; then
          service_name="nfs.server"
          check_sunos_service $service_name disabled
        fi
        check_file="/etc/system"
        check_file_value is $check_file "nfssrv:nfs_portmon" eq 1 star
      fi
      if [ "$os_name" = "Linux" ]; then
        for service_name in nfs nfslock portmap rpc nfs-kerner-server rpcbind; do
          check_systemctl_service disable $service_name
          check_chkconfig_service $service_name 3 off
          check_chkconfig_service $service_name 5 off
        done
      fi
      if [ "$os_name" = "FreeBSD" ]; then
        check_file="/etc/rc.conf"
        check_file_value is $check_file nfs_reserved_port_only eq YES hash
        check_file_value is $check_file weak_mountd_authentication eq NO hash
        check_file_value is $check_file rpc_lockd_enable eq NO hash
        check_file_value is $check_file rpc_statd_enable eq NO hash
        if [ "$os_version" -lt 5 ]; then
          check_file_value is $check_file portmap_enable eq NO hash
          check_file_value is $check_file nfs_server_enable eq NO hash
          check_file_value is $check_file single_mountd_enable eq NO hash
        else
          check_file_value is $check_file rpcbind_enable eq NO hash
          check_file_value is $check_file nfs_server_enable eq NO hash
          check_file_value is $check_file mountd_enable eq NO hash
        fi
      fi
    fi
  fi
}
