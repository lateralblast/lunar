#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_volfs
#
# Refer to Section(s) 2.8 Page(s) 20-1 CIS Solaris 11.1 Benchmark v1.0.0
#.


audit_volfs () {
  if [ "${os_name}" = "SunOS" ]; then
    verbose_message "Volume Management Daemons" "check"
    if [ "${os_version}" = "10" ]; then
      check_sunos_service "svc:/system/filesystem/volfs"    "disabled"
    fi
    if [ "${os_version}" = "11" ]; then
      check_sunos_service "svc:/system/filesystem/rmvolmgr" "disabled"
    fi
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      check_sunos_service "svc:/network/rpc/smserver"       "disabled"
    fi
    if [ "${os_version}" = "10" ]; then
      check_sunos_service "volmgt"                          "disabled"
    fi
  fi
}
