#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_inetd
#
# Check inetd
#
# Refer to Section(s) 10.6 Page(s) 141-2 CIS Solaris 10 Benchmark v1.1.0
#.

audit_inetd () {
  print_module "audit_inetd"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ] || [ "${os_version}" = "11" ]; then
      verbose_message     "Internet Services"  "check"
      check_sunos_service "svc:/network/inetd:default" "disabled"
    fi
  fi
}
