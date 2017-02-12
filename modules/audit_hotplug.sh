# audit_hotplug
#
# Turn off hotplug
#.

audit_hotplug () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "Hotplug Service"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        service_name="svc:/system/hotplug:default"
        check_sunos_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      service_name="pcscd"
      check_chkconfig_service $service_name 3 off
      check_chkconfig_service $service_name 5 off
      service_name="haldaemon"
      check_chkconfig_service $service_name 3 off
      check_chkconfig_service $service_name 5 off
      service_name="kudzu"
      check_chkconfig_service $service_name 3 off
      check_chkconfig_service $service_name 5 off
    fi
  fi
}
