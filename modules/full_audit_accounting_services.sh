#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# full_audit_accounting_services
#
# Audit accounting services
#.

full_audit_accounting_services() {
  audit_system_accounting
  audit_process_accounting
  audit_audit_class
  audit_sar_accounting
  audit_prelink
  audit_aide
}
