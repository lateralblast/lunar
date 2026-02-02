#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ppd_cache
#
# Cache for Printer Descriptions. Not required unless using print services.
#.

audit_ppd_cache () {
  print_function "audit_ppd_cache"
  string="PPD Cache"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ]; then
      check_sunos_service "svc:/application/print/ppd-cache-update:default" "disabled"
    fi
  else
    na_message "${string}"
  fi
}
