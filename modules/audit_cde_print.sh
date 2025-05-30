#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_cde_print
#
# CDE Printing services. Not required unless running CDE applications.
#.

audit_cde_print () {
  print_function "audit_cde_print"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ]; then
      verbose_message     "CDE Print" "check"
      check_sunos_service "svc:/application/cde-printinfo:default" "disabled"
    fi
  fi
}
