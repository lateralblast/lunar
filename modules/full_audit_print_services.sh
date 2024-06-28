#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# full_audit_print_services
#
# Audit print services
#.

full_audit_print_services () {
  audit_ppd_cache
  audit_print
  audit_cups
  audit_printer_sharing
}
