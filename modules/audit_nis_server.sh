# audit_nis_server
#
# These daemons are only required on systems that are acting as an
# NIS server for the local site. Typically there are only a small
# number of NIS servers on any given network.
# These services are disabled by default unless the system has been
# previously configured to act as a NIS server.
#.

audit_nis_server () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "NIS Server Daemons"
    fi
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
    done
  fi
}
