# audit_ticotsord
#
# Turn off ticotsord
#.

audit_ticotsord () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "Ticotsor Daemon"
      service_name="svc:/network/rpc-100235_1/rpc_ticotsord:default"
      funct_service $service_name disabled
    fi
  fi
}
