# audit_slp
#
# Turn off slp
#.

audit_slp () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message "SLP Daemon"
      service_name="svc:/network/slp:default"
      check_sunos_service $service_name disabled
    fi
  fi
}
