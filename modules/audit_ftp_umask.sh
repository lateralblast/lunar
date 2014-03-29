# audit_ftp_umask
#
# If FTP is permitted, set the umask value to apply to files created by the
# FTP server.
# Many users assume that files transmitted over FTP inherit their system umask
# value when they do not. This setting ensures that files transmitted over FTP
# are protected.
#
# Refer to Section(s) 2.12.10 Page(s) 214-5 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 7.4 Page(s) 65-6 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 7.7 Page(s) 106-7 CIS Solaris 10 v5.1.0
#.

audit_ftp_umask () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ]; then
    if [ "$os_name" = "AIX" ]; then
      check_file="/etc/inetd.conf"
      funct_file_value $check_file /usr/sbin/ftpd space "ftpd -l -u077" hash
    fi
    if [ "$os_name" = "SunOS" ]; then
      funct_verbose_message "Default umask for FTP Users"
      if [ "$os_version" = "10" ]; then
        check_file="/etc/ftpd/ftpaccess"
        funct_file_value $check_file defumask space 077 hash
      fi
      if [ "$os_version" = "11" ]; then
        check_file="/etc/proftpd.conf"
        funct_file_value $check_file Umask space 027 hash
      fi
    fi
  fi
}
