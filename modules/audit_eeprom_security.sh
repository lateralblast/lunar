# audit_eeprom_security
#
# Refer to Section(s) 6.15 Page(s) 59-60 CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 6.12 Page(s) 97-8  CIS Solaris 10 Benchmark v5.1.0
#.

audit_eeprom_security () {
  if [ "$os_name" = "SunOS" ]; then
    verbose_message "EEPROM Password"
    if [ "$audit_mode" = 2 ]; then
      echo "Restoring: EEPROM password to none"
      eeprom security-mode=none
    fi
    if [ "$audit_mode" != 2 ]; then
      eeprom_check=$( eeprom security-mode | awk -F= '{ print $2 }' )
      if [ "$gdm_check" = "none" ]; then
        if [ "$audit_mode" = 1 ]; then
          increment_insecure "EEPROM password is not enabled"
          verbose_message "" fix
          verbose_message "eeprom security-mode=command" fix
          verbose_message "eeprom security-#badlogins=0" fix
          verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          eeprom security-mode=command
          eeprom security-#badlogins=0
        fi
      else
        if [ "$audit_mode" = 1 ];then
          increment_secure "EEPROM password is enabled"
        fi
      fi
    fi
  fi
}
