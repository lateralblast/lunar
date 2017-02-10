# audit_ocfserv
#
# Turn off ocfserv
#.

audit_ocfserv () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message "OCF Service"
      service_name="svc:/network/rpc/ocfserv:default"
      check_sunos_service $service_name disabled
    fi
  fi
}
