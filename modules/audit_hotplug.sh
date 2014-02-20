# audit_hotplug
#
# Turn off hotplug
#.

audit_hotplug () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "Hotplug Service"
      service_name="svc:/system/hotplug:default"
      funct_service $service_name disabled
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "Hardware Daemons"
    service_name="pcscd"
    funct_chkconfig_service $service_name 3 off
    funct_chkconfig_service $service_name 5 off
    service_name="haldaemon"
    funct_chkconfig_service $service_name 3 off
    funct_chkconfig_service $service_name 5 off
    service_name="kudzu"
    funct_chkconfig_service $service_name 3 off
    funct_chkconfig_service $service_name 5 off
  fi
}
