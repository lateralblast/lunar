#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# full_audit_startup_services
#
# Audit startup services
#.

full_audit_startup_services () {
  audit_xinetd
  audit_chkconfig
  audit_legacy
  audit_inetd
  audit_inetd_logging
  audit_online_documentation
  audit_ncs
  audit_i4ls
}
