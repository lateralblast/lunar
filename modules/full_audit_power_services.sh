#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# full_audit_power_services
#.
# Audit power related services
#.

full_audit_power_services () {
  print_module "full_audit_power_services"
  audit_power_management
  audit_sys_suspend
}
