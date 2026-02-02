#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ticotsord
#
# Turn off ticotsord
#.

audit_ticotsord () {
  print_function "audit_ticotsord"
  string="Ticotsord Daemon"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      check_sunos_service "svc:/network/rpc-100235_1/rpc_ticotsord:default" "disabled"
    fi
  else
    na_message "${string}"
  fi
}
