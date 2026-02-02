#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_apocd
#
# Check APOC
#
# Turn off apocd
#.

audit_apocd () {
  print_function "audit_apocd"
  string="APOC Daemons"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      check_sunos_service "svc:/network/apocd/udp:default" "disabled"
    fi
  else
    na_message "${string}"
  fi
}
