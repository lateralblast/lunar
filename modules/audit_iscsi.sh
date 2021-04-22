# audit_iscsi
#
# Turn off iscsi target
#.

audit_iscsi () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "iSCSI Target Service"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        service_name="svc:/system/iscsitgt:default"
        check_sunos_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      for service_name in iscsi iscsid; do
        check_linux_service $service_name off
      done
    fi
  fi
}
