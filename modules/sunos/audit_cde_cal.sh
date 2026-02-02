#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_cde_cal () {
#
# Check Local CDE Calendar Manager
#
# Refer to Section(s) 2.1.2 Page(s) 18-9 CIS Solaris 10 v5.1.0
#.

audit_cde_cal () {
  print_function "audit_cde_cal"
  string="Local CDE Calendar Manager"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ]; then
      check_sunos_service "svc:/network/rpc/cde-calendar-manager:default" "disabled"
    fi
  else
    na_message "${string}"
  fi
}
