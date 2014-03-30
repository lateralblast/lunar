
# audit_ftp_server
#
# Turn off ftp server
#
# FTP does not protect the confidentiality of data or authentication
# credentials. It is recommended sftp be used if file transfer is required.
#
# Refer to Section 3.10 Page(s) 66 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_ftp_server () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "FTP Daemon"
    if [ "$os_anme" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        service_name="svc:/network/ftp:default"
        funct_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "Linux" ];then
      if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ]; then
        funct_linux_package uninstall vsftpd
      fi
    fi
  fi
}
