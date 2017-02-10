# audit_ftp_conf
#
# Audit FTP Configuration
#.

audit_ftp_conf () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "FTP users"
    if [ "$os_name" = "AIX" ]; then
      audit_ftp_users /etc/ftpusers
    fi
    if [ "$os_name" = "SunOS" ]; then
      audit_ftp_users /etc/ftpd/ftpusers
    fi
    if [ "$os_name" = "Linux" ]; then
      check_rpm vsftpd
      if [ "$rpm_check" = "vsftpd" ]; then
        audit_ftp_users /etc/vsftpd/ftpusers
      fi
    fi
  fi
}
