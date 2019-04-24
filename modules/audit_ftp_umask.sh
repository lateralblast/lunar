# audit_ftp_umask
#
# Refer to Section(s) 2.12.10 Page(s) 214-5 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 7.4     Page(s) 65-6  CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 7.7     Page(s) 106-7 CIS Solaris 10 Benchmark v5.1.0
#.

audit_ftp_umask () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "Default umask for FTP Users"
    if [ "$os_name" = "AIX" ]; then
      check_file="/etc/inetd.conf"
      check_file_value is $check_file /usr/sbin/ftpd space "ftpd -l -u077" hash
    fi
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ]; then
        check_file="/etc/ftpd/ftpaccess"
        check_file_value is $check_file defumask space 077 hash
      fi
      if [ "$os_version" = "11" ]; then
        check_file="/etc/proftpd.conf"
        check_file_value is $check_file Umask space 027 hash
      fi
    fi
  fi
}
