#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_system_x86
#
# Audit x86
#.

audit_system_x86 () {
  if [ "$os_name" = "SunOS" ]; then
    audit_grub_security
    audit_kdm_config
  fi
}
