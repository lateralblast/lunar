#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# full_audit_update_services
#
# Update services
#.

full_audit_update_services () {
  apply_latest_patches
  audit_yum_conf
  audit_software_update
}
