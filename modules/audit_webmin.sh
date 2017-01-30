# audit_webmin
#
# Turn off webmin if it is not being used.
#.

audit_webmin () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "Webmin Daemon"
      service_name="svc:/application/management/webmin:default"
      funct_service $service_name disabled
    fi
  fi
}
