#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_network_connections
#
# Auditing of Incoming Network Connections
#.

audit_network_connections () {
  print_function "audit_network_connections"
  string="Auditing of Incomming Network Connections"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "11" ]; then
      check_append_file "/etc/security/audit_event" "lck:AUE_ACCEPT"        "hash"
      check_append_file "/etc/security/audit_event" "lck:AUE_CONNECT"       "hash"
      check_append_file "/etc/security/audit_event" "lck:AUE_SOCKACCEPT"    "hash"
      check_append_file "/etc/security/audit_event" "lck:AUE_SOCKCONNECT"   "hash"
      check_append_file "/etc/security/audit_event" "lck:AUE_inetd_connect" "hash"
    fi
  else
    na_message "${string}"
  fi
}
