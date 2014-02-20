# audit_nobody_rpc
#
# The keyserv process, if enabled, stores user keys that are utilized with
# Sun's Secure RPC mechanism.
# The action listed prevents keyserv from using default keys for the nobody
# user, effectively stopping this user from accessing information via Secure
# RPC.
#.

audit_nobody_rpc () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      funct_verbose_message "Nobody Access for RPC Encryption Key Storage Service"
      check_file="/etc/default/keyserv"
      funct_file_value $check_file ENABLE_NOBODY_KEYS eq NO hash
    fi
  fi
}
