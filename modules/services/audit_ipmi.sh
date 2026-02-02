#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ipmi
#
# Turn off ipmi environment daemon
#.

audit_ipmi () {
  print_function "audit_ipmi"
  string="IPMI"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "Linux" ]; then
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
        check_sunos_service "svc:/network/ipmievd:default" "disabled"
      fi
    fi
    if [ "${os_name}" = "Linux" ]; then
      check_linux_service "ipmi" "off"
    fi
  else
    na_message "${string}"
  fi
}
