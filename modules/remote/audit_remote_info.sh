#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_remote_info
#
# Turn off remote info services like rstat and finger
#
# Refer to Section(s) 1.3.16 Page(s) 52-3 CIS AIX Benchmark v1.1.0
#.

audit_remote_info () {
  print_function "audit_remote_info"
  string="Remote Information Services"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ] || [ "${os_name}" = "AIX" ]; then
    if [ "${os_name}" = "AIX" ]; then
      check_rctcp "rwhod" "off"
    fi
    if [ "${os_name}" = "SunOS" ]; then
      if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
        check_sunos_service "svc:/network/rpc/rstat:default"  "disabled"
        check_sunos_service "svc:/network/nfs/rquota:default" "disabled"
        check_sunos_service "svc:/network/rpc/rusers:default" "disabled"
        check_sunos_service "svc:/network/finger:default"     "disabled"
        check_sunos_service "svc:/network/rpc/wall:default"   "disabled"
      fi
    fi
  else
    na_message "${string}"
  fi
}
