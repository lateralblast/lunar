#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_vnetd
#
# VNET Daemon
#
# Turn off vnetd
#.

audit_vnetd () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message     "VNET Daemon" "check"
      check_sunos_service "svc:/network/vnetd/tcp:default" "disabled"
    fi
  fi
}
