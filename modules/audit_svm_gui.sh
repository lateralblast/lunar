#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_svm_gui
#
# Check Solaris Volume Manager GUI daemons disabled
#
# Refer to Section(s) 2.2.13 Page(s) 33-4 CIS Solaris 10 Benchmark v5.1.0
#.

audit_svm_gui () {
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${os_version}" = "10" ]; then
      verbose_message     "Solaris Volume Manager GUI Daemons" "check"
      check_sunos_service "svc:/network/rpc/mdcomm"  "disabled"
      check_sunos_service "svc:/network/rpc/meta"    "disabled"
      check_sunos_service "svc:/network/rpc/metamed" "disabled"
      check_sunos_service "svc:/network/rpc/metamh"  "disabled"
    fi
  fi
}
