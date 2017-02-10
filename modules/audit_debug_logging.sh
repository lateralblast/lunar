# audit_debug_logging
#
# Connections to server should be logged so they can be audited in the event
# of and attack.
#.

audit_debug_logging () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      verbose_message "Connection Logging"
      audit_logadm_value connlog daemon.debug
    fi
  fi
}
