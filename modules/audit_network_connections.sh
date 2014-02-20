# audit_network_connections
#
# Auditing of Incoming Network Connections
#.

audit_network_connections () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "11" ]; then
      funct_verbose_message "Auditing of Incomming Network Connections"
      funct_append_file $check_file "lck:AUE_ACCEPT" hash
      funct_append_file $check_file "lck:AUE_CONNECT" hash
      funct_append_file $check_file "lck:AUE_SOCKACCEPT" hash
      funct_append_file $check_file "lck:AUE_SOCKCONNECT" hash
      funct_append_file $check_file "lck:AUE_inetd_connect" hash
    fi
  fi
}
