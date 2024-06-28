#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_boot_server
#
# Turn off boot services
#.

audit_boot_server () {
  audit_rarp
  audit_bootparams
  audit_tftp_server
  audit_dhcp_server
}
