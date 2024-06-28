#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_gss
#
# Check Generic Security Services
#
# Refer to Section(s) 2.7   Page(s) 19-20 CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 2.2.7 Page(s) 27    CIS Solaris 10 Benchmark v5.1.0
#.

audit_gss () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message     "Generic Security Services" "check"
      check_sunos_service "svc:/network/rpc/gss"      "disabled"
    fi
  fi
}
