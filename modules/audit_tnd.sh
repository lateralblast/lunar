# audit_tnd
#
# Turn off tnd
#.

audit_tnd () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "TN Daemon"
      service_name="svc:/network/tnd:default"
      funct_service $service_name disabled
    fi
  fi
}
