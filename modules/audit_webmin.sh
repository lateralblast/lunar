# audit_webmin
#
# Turn off webmin if it is not being used.
#.

audit_webmin () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message "Webmin Daemon"
      service_name="svc:/application/management/webmin:default"
      check_sunos_service $service_name disabled
    fi
  fi
}
