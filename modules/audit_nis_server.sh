# audit_nis_server
#
# These daemons are only required on systems that are acting as an
# NIS server for the local site. Typically there are only a small
# number of NIS servers on any given network.
# These services are disabled by default unless the system has been
# previously configured to act as a NIS server.
#
# Refer to Section(s) 2.1.7 Page(s) 51-52 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 3.12-3 Page(s) 13-14 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 2.4 Page(s) 17-8 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 2.2.2 Page(s) 23-4 CIS Solaris 10 v5.1.0
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
      funct_file_value $check_file nis_server_enable eq NO hash
      funct_file_value $check_file nis_ypxfrd_enable eq NO hash
      funct_file_value $check_file nis_yppasswdd_enable eq NO hash
      funct_file_value $check_file rpc_ypupdated_enable eq NO hash
      funct_file_value $check_file nis_client_enable eq NO hash
      funct_file_value $check_file nis_ypset_enable eq NO hash
    fi
  fi
}
