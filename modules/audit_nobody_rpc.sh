# audit_nobody_rpc
#
# Refer to Section(s) 6.2 Page(s) 47 CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 6.3 Page(s) 88 CIS Solaris 10 Benchmark v5.1.0
#.

audit_nobody_rpc () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      verbose_message "Nobody Access for RPC Encryption Key Storage Service"
      check_file="/etc/default/keyserv"
      check_file_value is $check_file ENABLE_NOBODY_KEYS eq NO hash
    fi
  fi
}
