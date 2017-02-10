# audit_system_sparc
#
# Audit SPARC
#.

audit_system_sparc () {
  if [ "$os_name" = "SunOS" ]; then
    audit_eeprom_security
  fi
}
