#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_nisplus
#
# Check NIS+ daemons
#
# Refer to Section(s) 2.2.4 Page(s) 25 CIS Solaris 10 Benchmark v5.1.0
#.

audit_nisplus () {
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ]; then
      verbose_message     "NIS+ Daemons"             "check"
      check_sunos_service "svc:/network/rpc/nisplus" "disabled"
    fi
  fi
}
