#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# full_audit_other_daemons
#
# Audit other daemons and startup services
#.

full_audit_other_daemons () {
  audit_xinetd
  audit_other_daemons
  audit_legacy
  audit_inetd
  audit_inetd_logging
  audit_online_documentation
  audit_ncs
  audit_i4ls
}
