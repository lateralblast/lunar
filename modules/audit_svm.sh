#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_svm
#
# Check volume manager daemons disabled
#
# Refer to Section(s) 2.2.8,12 Page(s) 28,32-3 CIS Solaris 10 Benchmark v5.1.0
#.

audit_svm () {
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ]; then
      verbose_message       "Solaris Volume Manager Daemons"    "check"
      check_sunos_service   "svc:/system/metainit"              "disabled"
      check_sunos_service   "svc:/system/mdmonitor"             "disabled"
      if [ "${os_update}" -lt 4 ]; then
        check_sunos_service "svc:/platform/sun4u/mpxio-upgrade" "disabled"
      else
        check_sunos_service "svc:/system/device/mpxio-upgrade"  "disabled"
      fi
    fi
  fi
}
