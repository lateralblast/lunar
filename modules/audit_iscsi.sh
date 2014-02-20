# audit_iscsi
#
# Turn off iscsi target
#.

audit_iscsi () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "iSCSI Target Service"
      service_name="svc:/system/iscsitgt:default"
      funct_service $service_name disabled
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "iSCSI Target Service"
    service_name="iscsi"
    funct_chkconfig_service $service_name 3 off
    funct_chkconfig_service $service_name 5 off
    service_name="iscsd"
    funct_chkconfig_service $service_name 3 off
    funct_chkconfig_service $service_name 5 off
  fi
}
