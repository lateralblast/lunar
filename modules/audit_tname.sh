# audit_tname
#
# Turn off tname
#.

audit_tname () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message "Tname Daemon"
      service_name="svc:/network/tname:default"
      check_sunos_service $service_name disabled
    fi
  fi
}
