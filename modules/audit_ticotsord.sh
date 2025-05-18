#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ticotsord
#
# Turn off ticotsord
#.

audit_ticotsord () {
  print_module "audit_ticotsord"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      verbose_message     "Ticotsor Daemon"                                 "check"
      check_sunos_service "svc:/network/rpc-100235_1/rpc_ticotsord:default" "disabled"
    fi
  fi
}
