# audit_network_connections
#
# Auditing of Incoming Network Connections
#.

audit_network_connections () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "11" ]; then
      check_file="/etc/security/audit_event"
      verbose_message "Auditing of Incomming Network Connections"
      check_append_file $check_file "lck:AUE_ACCEPT" hash
      check_append_file $check_file "lck:AUE_CONNECT" hash
      check_append_file $check_file "lck:AUE_SOCKACCEPT" hash
      check_append_file $check_file "lck:AUE_SOCKCONNECT" hash
      check_append_file $check_file "lck:AUE_inetd_connect" hash
    fi
  fi
}
