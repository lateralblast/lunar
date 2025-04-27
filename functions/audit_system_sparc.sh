#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_system_sparc
#
# Audit SPARC
#.

audit_system_sparc () {
  if [ "${os_name}" = "SunOS" ]; then
    audit_eeprom_security
  fi
}
