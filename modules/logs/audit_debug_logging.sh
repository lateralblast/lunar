#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_debug_logging
#
# Connections to server should be logged so they can be audited in the event
# of and attack.
#.

audit_debug_logging () {
  print_function "audit_debug_logging"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ]; then
      verbose_message    "Connection Logging" "check"
      audit_logadm_value "connlog"            "daemon.debug"
    fi
  fi
}
