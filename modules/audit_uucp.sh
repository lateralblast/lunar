# audit_uucp
#
# Turn off uucp and swat
#.

audit_uucp () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "Samba Web Configuration Deamon"
      service_name="svc:/network/swat:default"
      funct_service $service_name disabled
    fi
    if [ "$os_version" = "10" ]; then
      funct_verbose_message "UUCP Service"
      service_name="uucp"
      funct_service $service_name disabled
    fi
  fi
}
