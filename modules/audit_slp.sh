#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_slp
#
# Turn off slp
#.

audit_slp () {
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      verbose_message     "SLP Daemon"                "check"
      check_sunos_service "svc:/network/slp:default"  "disabled"
    fi
  fi
}
