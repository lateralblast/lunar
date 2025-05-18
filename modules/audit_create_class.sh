#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_create_class
#
# Creating Audit Classes improves the auditing capabilities of Solaris.
#
# Refer to Section(s) 4.1-5 Page(s) 39-45 CIS Solaris 11.1 v1.0.0
#.

audit_create_class () {
  print_module "audit_create_class"
  if [ "${os_name}" = "SunOS" ]; then
    check_file="/etc/security/audit_class"
    if [ -f "${check_file}" ]; then
      verbose_message "Audit Classes" "check"
      check_append_file "${check_file}" "0x0100000000000000:lck:Security Lockdown" "hash"
    fi
  fi
}
