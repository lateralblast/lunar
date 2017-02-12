# audit_winbind
#
# Turn off winbind if not required
#.

audit_winbind () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "Winbind Daemon"
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      service_name="svc:/network/winbind:default"
      check_sunos_service $service_name disabled
    fi
    if [ "$os_name" = "Linux" ]; then
      service_name="winbind"
      check_chkconfig_service $service_name 3 off
      check_chkconfig_service $service_name 5 off
    fi
  fi
}
