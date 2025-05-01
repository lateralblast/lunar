#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# full_audit_other_services
#
# Other remaining services
#.

full_audit_other_services () {
  audit_bluetooth
  audit_postgresql
  audit_encryption_kit
  audit_biosdevname
  audit_apport
  audit_pae
}
