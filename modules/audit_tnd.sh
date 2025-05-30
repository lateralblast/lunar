#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_tnd
#
# Turn off tnd
#.

audit_tnd () {
  print_function "audit_tnd"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      verbose_message     "TN Daemon"                "check"
      check_sunos_service "svc:/network/tnd:default" "disabled"
    fi
  fi
}
