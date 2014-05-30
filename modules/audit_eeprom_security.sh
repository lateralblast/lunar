# audit_eeprom_security
#
# Oracle SPARC systems support the use of a EEPROM password for the console.
# Setting the EEPROM password helps prevent attackers with physical access to
# the system console from booting off some external device (such as a CD-ROM
# or floppy) and subverting the security of the system.
#
# Refer to Section(s) 6.15 Page(s) 59-60 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 6.12 Page(s) 97-8 CIS Solaris 10 v5.1.0
#.

audit_eeprom_security () {
  if [ "$os_name" = "SunOS" ]; then
    funct_verbose_message "EEPROM Password"
    if [ "$audit_mode" = 2 ]; then
      echo "Restoring: EEPROM password to none"
      eeprom security-mode=none
    else
      echo "Checking:  EEPROM password is enabled"
    fi
    total=`expr $total + 1`
    if [ "$audit_mode" != 2 ]; then
      eeprom_check=`eeprom security-mode | awk -F= '{ print $2 }'`
      if [ "$gdm_check" = "none" ]; then
        if [ "$audit_mode" = 1 ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   EEPROM password is not enabled [$insecure Warnings]"
          funct_verbose_message "" fix
          funct_verbose_message "eeprom security-mode=command" fix
          funct_verbose_message "eeprom security-#badlogins=0" fix
          funct_verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          eeprom security-mode=command
          eeprom security-#badlogins=0
        fi
      else
        if [ "$audit_mode" = 1 ];then
          secure=`expr $secure + 1`
          echo "Secure:    EEPROM password is enabled [$secure Passes]"
        fi
      fi
    fi
  fi
}
