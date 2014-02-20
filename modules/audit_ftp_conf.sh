# audit_ftp_conf
#
# Audit FTP Configuration
#.

audit_ftp_conf () {
  funct_verbose_message "FTP users"
  if [ "$os_name" = "SunOS" ]; then
    audit_ftp_users /etc/ftpd/ftpusers
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_rpm_check vsftpd
    if [ "$rpm_check" = "vsftpd" ]; then
      audit_ftp_users /etc/vsftpd/ftpusers
    fi
  fi
}
