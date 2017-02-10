# audit_ticotsord
#
# Turn off ticotsord
#.

audit_ticotsord () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message "Ticotsor Daemon"
      service_name="svc:/network/rpc-100235_1/rpc_ticotsord:default"
      check_sunos_service $service_name disabled
    fi
  fi
}
