# audit_ftp_logging
#
# Information about FTP sessions will be logged via syslogd (1M),
# but the system must be configured to capture these messages.
# If the FTP daemon is installed and enabled, it is recommended that the
# "debugging" (-d) and connection logging (-l) flags also be enabled to
# track FTP activity on the system. Note that enabling debugging on the FTP
# daemon can cause user passwords to appear in clear-text form in the system
# logs, if users accidentally type their passwords at the username prompt.
# All of this information is logged by syslogd (1M), but syslogd (1M) must be
# configured to capture this information to a separate file so it may be more
# easily reviewed.
#
# Refer to Section(s) 4.2 Page(s) 67 CIS Solaris 10 v5.1.0
#.

audit_ftp_logging () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      funct_verbose_message "FTPD Daemon Logging"
      get_command="svcprop -p inetd_start/exec svc:/network/ftp:default"
      check_value=`$get_command |grep "\-d" | wc -l`
      file_header="ftpd_logging"
      if [ "$audit_mode" != 2 ]; then
        echo "Checking:  File $file_header"
      fi
      log_file="$work_dir/$file_header.log"
      total=`expr $total + 1`
      if [ "$audit_mode" = 1 ]; then
        if [ "$check_value" -eq 0 ]; then
          insecure=`expr $insecure + 1`
          echo "Warning:   FTP daemon logging not enabled [$insecure Warnings]"
          funct_verbose_message "" fix
          funct_verbose_message "inetadm -m svc:/network/ftp exec=\"/usr/sbin/in.ftpd -a -l -d\"" fix
          funct_verbose_message "" fix
        else
          secure=`expr $secure + 1`
          echo "Secure:    FTP daemon logging enabled [$secure Passes]"
        fi
      else
        if [ "$audit_mode" = 0 ]; then
          if [ "$check_value" -eq 0 ]; then
            echo "Setting:   FTP daemon logging to enabled"
            $get_command > $log_file
            inetadm -m svc:/network/ftp exec="/usr/sbin/in.ftpd -a -l -d"
          fi
        else
          if [ "$audit_mode" = 2 ]; then
            restore_file="$restore_dir/$file_header.log"
            if [ -f "$restore_file" ]; then
              exec_string=`cat $restore_file`
              echo "Restoring: Previous value for FTP daemon to $exec_string"
              inetadm -m svc:/network/ftp exec="$exec_string"
            fi
          fi
        fi
      fi
    fi
  fi
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "FTPD Daemon Message"
    funct_rpm_check vsftpd
    if [ "$rpm_check" = "vsftpd" ]; then
      check_file="/etc/vsftpd.conf"
      if [ -f "$check_file" ]; then
        funct_file_value $check_file log_ftp_protocol eq YES hash
        funct_file_value $check_file ftpd_banner eq "Authorized users only. All activity may be monitored and reported." hash
        funct_check_perms $check_file 0600 root root
      fi
      check_file="/etc/vsftpd/vsftpd.conf"
      if [ -f "$check_file" ]; then
        funct_file_value $check_file log_ftp_protocol eq YES hash
        funct_file_value $check_file ftpd_banner eq "Authorized users only. All activity may be monitored and reported." hash
        funct_check_perms $check_file 0600 root root
      fi
    fi
  fi
}
