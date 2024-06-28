#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_ppd_cache
#
# Cache for Printer Descriptions. Not required unless using print services.
#.

audit_ppd_cache () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      verbose_message     "PPD Cache" "check"
      check_sunos_service "svc:/application/print/ppd-cache-update:default" "disabled"
    fi
  fi
}
