#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_eeprom_security
#
# Check EEPROM security
#
# Refer to Section(s) 6.15 Page(s) 59-60 CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 6.12 Page(s) 97-8  CIS Solaris 10 Benchmark v5.1.0
#.

audit_eeprom_security () {
  print_function "audit_eeprom_security"
  string="EEPROM Password"
  check_message "${string}"
  if [ "${os_name}" = "SunOS" ]; then
    if [ "${audit_mode}" = 2 ]; then
      echo "EEPROM password to none" "restore"
      eeprom security-mode=none
    fi
    if [ "${audit_mode}" != 2 ]; then
      eeprom_check=$( eeprom security-mode | awk -F= '{ print $2 }' )
      if [ "${eeprom_check}" = "none" ]; then
        if [ "${audit_mode}" = 1 ]; then
          increment_insecure "EEPROM password is not enabled"
          verbose_message    "eeprom security-mode=command"   "fix"
          verbose_message    "eeprom security-#badlogins=0"   "fix"
        fi
        if [ "${audit_mode}" = 0 ]; then
          eeprom security-mode=command
          eeprom security-#badlogins=0
        fi
      else
        if [ "${audit_mode}" = 1 ];then
          increment_secure   "EEPROM password is enabled"
        fi
      fi
    fi
  else
    na_message "${string}"
  fi
}
