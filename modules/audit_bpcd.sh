# audit_bpcd
#
# Turn off bpcd
#.

audit_bpcd () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message "BPC Daemon"
      service_name="svc:/network/bpcd/tcp:default"
      check_sunos_service $service_name disabled
    fi
  fi
}
