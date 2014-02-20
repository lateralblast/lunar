# audit_ftp_umask
#
# If FTP is permitted, set the umask value to apply to files created by the
# FTP server.
# Many users assume that files transmitted over FTP inherit their system umask
# value when they do not. This setting ensures that files transmitted over FTP
# are protected.
#.

audit_ftp_umask () {
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
}
