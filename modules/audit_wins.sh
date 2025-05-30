#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_wins
#
# Turn off wins if not required
#.

audit_wins () {
  print_function "audit_wins"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      verbose_message     "WINS Daemon"               "check"
      check_sunos_service "svc:/network/wins:default" "disabled"
    fi
  fi
}
