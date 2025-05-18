#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_labeld
#
# Turn off labeld
#.

audit_labeld () {
  print_module "audit_labeld"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      verbose_message     "Label Daemon" "check"
      check_sunos_service "svc:/system/labeld:default" "disabled"
    fi
  fi
}
