# audit_nis_server
#
# These daemons are only required on systems that are acting as an
# NIS server for the local site. Typically there are only a small
# number of NIS servers on any given network.
# These services are disabled by default unless the system has been
# previously configured to act as a NIS server.
#
# Refer to Section 2.1.7 Page(s) 51-52 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section 3.7-8 Page(s) 11-12 CIS FreeBSD Benchmark v1.0.5
#.

audit_nis_server () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    funct_verbose_message "NIS Server Daemons"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ]; then
        service_name="svc:/network/nis/server"
        funct_service $service_name disabled
        service_name="svc:/network/nis/passwd"
        funct_service $service_name disabled
        service_name="svc:/network/nis/update"
        funct_service $service_name disabled
        service_name="svc:/network/nis/xfr"
        funct_service $service_name disabled
      fi
      if [ "$os_version" = "11" ]; then
        service_name="svc:/network/nis/server"
        funct_service $service_name disabled
        service_name="svc:/network/nis/domain"
        funct_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      funct_verbose_message "NIS Server Daemons"
      for service_name in yppasswdd ypserv ypxfrd; do
        funct_chkconfig_service $service_name 3 off
        funct_chkconfig_service $service_name 5 off
        if [ "$os_vendor" = "CentOS" ]; then
          funct_linux_package uninstall $service_name
        fi
      done
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      check_file="/etc/rc.conf"
      funct_file_value $check_file rpc_lockd_enable eq NO hash
      funct_file_value $check_file rpc_statd_enable eq NO hash
      if [ "$os_version" < 5 ]; then
        funct_file_value $check_file portmap_enable eq NO hash
        funct_file_value $check_file nfs_server_enable eq NO hash
        funct_file_value $check_file single_mountd_enable eq NO hash
      else
        funct_file_value $check_file rpcbind_enable eq NO hash
        funct_file_value $check_file nfs_server_enable eq NO hash
        funct_file_value $check_file mountd_enable eq NO hash
      fi
    fi
  fi
}
