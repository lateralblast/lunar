# audit_nis_client
#
# If the local site is not using the NIS naming service to distribute
# system and user configuration information, this service may be disabled.
# This service is disabled by default unless the NIS service has been
# configured on the system.
#.

audit_nis_client () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "NIS Client Daemons"
      service_name="svc:/network/nis/client"
      funct_service $service_name disabled
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "NIS Client Daemons"
    service_name="ypbind"
    funct_chkconfig_service $service_name 3 off
    funct_chkconfig_service $service_name 5 off
  fi
}
