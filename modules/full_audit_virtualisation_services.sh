#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# full_audit_virtualisation_services
#
# Audit vitualisation services
#.

full_audit_virtualisation_services () {
  print_module "full_audit_virtualisation_services"
  audit_zones
  audit_xen
}
