# audit_iscsi
#
# Turn off iscsi target
#.

audit_iscsi () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message "iSCSI Target Service"
      service_name="svc:/system/iscsitgt:default"
      check_sunos_service $service_name disabled
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    verbose_message "iSCSI Target Service"
    service_name="iscsi"
    check_chkconfig_service $service_name 3 off
    check_chkconfig_service $service_name 5 off
    service_name="iscsd"
    check_chkconfig_service $service_name 3 off
    check_chkconfig_service $service_name 5 off
  fi
}
