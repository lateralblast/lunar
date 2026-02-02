#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_cde_spc
#
# CDE Subprocess control. Not required unless running CDE applications.
#.

audit_cde_spc () {
  print_function "audit_cde_spc"
  string="CDE Subprocess control"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ]; then
      check_sunos_service "svc:/network/cde-spc:default"  "disabled"
    fi
  else
    na_message "${string}"
  fi
}
