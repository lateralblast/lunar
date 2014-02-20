# funct_audit_system_sparc
#
# Audit SPARC
#.

funct_audit_system_sparc () {
  if [ "$os_name" = "SunOS" ]; then
    audit_eeprom_security
  fi
}
