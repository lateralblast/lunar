# audit_tftp_server
#
# Turn off tftp
#.

audit_tftp_server () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "TFTPD Daemon"
      service_name="svc:/network/tftp/udp6:default"
      funct_service $service_name disabled
      service_name="svc:/network/tftp/udp4:default"
      funct_service $service_name disabled
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "TFTPD Daemon"
    funct_chkconfig_service tftp 3 off
    funct_chkconfig_service tftp 5 off
    if [ -e "/tftpboot" ]; then
      funct_check_perms /tftpboot 0744 root root
    fi
  fi
}
