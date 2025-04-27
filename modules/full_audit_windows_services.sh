#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# full_audit_windows_services
#
# Audit windows services
#.

full_audit_windows_services () {
  audit_smbpasswd_perms
  audit_smbconf_perms
  audit_samba
  audit_wins
  audit_winbind
}
