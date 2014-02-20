# audit_cups
#
# Printing Services Turn off cups if not required on Linux.
#.

audit_cups () {
  if [ "$os_name" = "Linux" ]; then
    funct_rpm_check cups
    if [ "$rpm_check" = "cups" ]; then
      funct_verbose_message "Printing Services"
      service_name="cups"
      funct_chkconfig_service $service_name 3 off
      funct_chkconfig_service $service_name 5 off
      service_name="cups-lpd"
      funct_chkconfig_service $service_name 3 off
      funct_chkconfig_service $service_name 5 off
      service_name="cupsrenice"
      funct_chkconfig_service $service_name 3 off
      funct_chkconfig_service $service_name 5 off
      funct_check_perms /etc/init.d/cups 0744 root root
      funct_check_perms /etc/cups/cupsd.conf 0600 lp sys
      funct_check_perms /etc/cups/client.conf 0644 root lp
      funct_file_value /etc/cups/cupsd.conf User space lp hash
      funct_file_value /etc/cups/cupsd.conf Group space sys hash
    fi
  fi
}
