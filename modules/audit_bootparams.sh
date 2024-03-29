# audit_bootparams
#
# Turn off bootparamd
#.

audit_bootparams () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "Bootparams Daemon"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        service_name="svc:/network/rpc/bootparams:default"
        check_sunos_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      service_name="bootparamd"
      check_linux_service $service_name off
    fi
  fi
}
