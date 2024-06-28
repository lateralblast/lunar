#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_kerberos_tgt
#
# Check Kerberos Ticket Warning
#
# Refer to Section(s) 2.6   Page(s) 19   CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 2.2.6 Page(s) 26-7 CIS Solaris 10 Benchmark v5.1.0
#.

audit_kerberos_tgt () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      verbose_message     "Kerberos Ticket Warning" "check"
      check_sunos_service "svc:/network/security/ktkt_warn" "disabled"
    fi
  fi
}
