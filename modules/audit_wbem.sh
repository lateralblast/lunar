#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_wbem
#
# Turn off Web Based Enterprise Management
#
# Refer to Section(s) 2.1.6 Page(s) 21-2 CIS Solaris 10 Benchmark v5.1.0
#.

audit_wbem () {
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ]; then
      verbose_message     "Web Based Enterprise Management" "check"
      check_sunos_service "svc:/application/management/wbem" "disabled"
    fi
  fi
}
