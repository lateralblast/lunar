
# audit_ftp_banner
#
# Refer to Section(s) 2.12.11 Page(s) 215-6 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 8.4     Page(s) 70-1  CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 8.4     Page(s) 114   CIS Solaris 10 Benchmark v5.1.0
#.

audit_ftp_banner () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "FTP Warning Banner"
    if [ "$os_name" = "AIX" ]; then
      package_name="bos.msg.$language_suffix.net.tcp.client"
      check_lslpp $package_name
      if [ "$lslpp_check" = "$package_name" ]; then
        message_file="/usr/lib/nls/msg/$language_suffix/ftpd.cat"
        actual_value=$( dspcat -g $message_file | grep "^9[[:blank:]]" | awk '{print $3}' )
        if [ "$audit_mode" != 2 ]; then
          if [ "actual_value" != "Authorised" ]; then
            if [ "$audit_mode" = 1 ]; then
              increment_secure "FTP warning message isn't enabled"
              verbose_message "" fix
              verbose_message "dspcat -g /usr/lib/nls/msg/en_US/ftpd.cat > /tmp/ftpd.tmp" fix
              verbose_message "sed \"s/\"\%s FTP server (\%s) ready.\"/\"\%s Authorised uses only. All activity may be monitored and reported\"/\" /tmp/ftpd.tmp > /tmp/ftpd.msg" fix
              verbose_message "gencat /usr/lib/nls/msg/en_US/ftpd.cat /tmp/ftpd.msg" fix
              verbose_message "rm /tmp/ftpd.tmp /tmp/ftpd.msg" fix
              verbose_message "" fix
            fi
            if [ "$audit_mode" = 0 ]; then
              backup_file $message_file
              dspcat -g /usr/lib/nls/msg/en_US/ftpd.cat > /tmp/ftpd.tmp
              sed "s/\"\%s FTP server (\%s) ready.\"/\"\%s Authorised uses only. All activity may be monitored and reported\"/" /tmp/ftpd.tmp > /tmp/ftpd.msg
              gencat /usr/lib/nls/msg/en_US/ftpd.cat /tmp/ftpd.msg
              rm /tmp/ftpd.tmp /tmp/ftpd.msg
            fi
          else
            if [ "$audit_mode" = 1 ]; then
              increment_secure "FTP warning message enabled"
            fi
          fi
        else
          restore_file $message_file $restore_dir
        fi
      else
        verbose_message "" fix
        verbose_message "Package $package_name is not installed" fix
        verbose_message "" fix
      fi
    fi
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ]; then
        check_file="/etc/ftpd/banner.msg"
        check_file_value is $check_file Authorised space "users only" hash
        if [ "$audit_mode" = 0 ]; then
          check_file_perms $check_file 0444 root root
        fi
      fi
      if [ "$os_version" = "11" ]; then
        check_file="/etc/proftpd.conf"
        check_file_value is $check_file DisplayConnect space /etc/issue hash
        if [ "$audit_mode" = 0 ]; then
          svcadm restart ftp
        fi
      fi
    fi
  fi
}
