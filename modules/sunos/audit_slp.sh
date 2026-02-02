#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_slp
#
# Turn off slp
#.

audit_slp () {
  print_function "audit_slp"
  string="SLP Daemon"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      check_sunos_service "svc:/network/slp:default"  "disabled"
    fi
  else
    na_message "${string}"
  fi
}
