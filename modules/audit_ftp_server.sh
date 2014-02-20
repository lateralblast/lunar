
# audit_ftp_server
#
# Turn off ftp server
#.

audit_ftp_server () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
      funct_verbose_message "FTP Daemon"
      service_name="svc:/network/ftp:default"
      funct_service $service_name disabled
    fi
  fi
}
