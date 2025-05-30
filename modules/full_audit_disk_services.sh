#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# full_audit_disk_services
#
# Audit disk and hardware related services
#.

full_audit_disk_services () {
  print_function "full_audit_disk_services"
  audit_svm
  audit_svm_gui
  audit_iscsi
}
