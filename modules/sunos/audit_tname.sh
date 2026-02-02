#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_tname
#
# Turn off tname
#.

audit_tname () {
  print_function "audit_tname"
  string="Tname Daemon"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      check_sunos_service "svc:/network/tname:default" "disabled"
    fi
  else
    na_message "${string}"
  fi
}
