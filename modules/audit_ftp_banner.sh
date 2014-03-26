
# audit_ftp_banner
#
# The action for this item sets a warning message for FTP users before they
# log in. Warning messages inform users who are attempting to access the
# system of their legal status regarding the system. Consult with your
# organization's legal counsel for the appropriate wording for your
# specific organization.
#
# Refer to Section(s) 2.12.11 Page(s) 215-6 CIS AIX Benchmark v1.1.0
#.

audit_ftp_banner () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ]; then
    funct_verbose_message "FTP Warning Banner"
    if [ "$os_name" = "AIX" ]; then
      package_name="bos.msg.$language_suffix.net.tcp.client"
      funct_lslpp_check $package_name
      if [ "$lslpp_check" = "$package_name" ]; then
        message_file="/usr/lib/nls/msg/$language_suffix/ftpd.cat"
        actual_value=`dspcat -g $message_file | grep "^9[[:blank:]]" |awk '{print $3}'`
        if [ "$audit_mode" != 2 ]; then
          echo "Checking:  FTP warning message"
          if [ "actual_value" != "Authorised" ]; then
            if [ "$audit_mode" = 1 ]; then
              total=`expr $total + 1`
              score=`expr $score - 1`
              echo "Secure:    FTP warning message isn't enabled [$score]"
              funct_verbose_message "" fix
              funct_verbose_message "dspcat -g /usr/lib/nls/msg/en_US/ftpd.cat > /tmp/ftpd.tmp" fix
              funct_verbose_message "sed \"s/\"\%s FTP server (\%s) ready.\"/\"\%s Authorised uses only. All activity may be monitored and reported\"/\" /tmp/ftpd.tmp > /tmp/ftpd.msg" fix
              funct_verbose_message "gencat /usr/lib/nls/msg/en_US/ftpd.cat /tmp/ftpd.msg" fix
              funct_verbose_message "rm /tmp/ftpd.tmp /tmp/ftpd.msg" fix
              funct_verbose_message "" fix
            fi
            if [ "$audit_mode" = 0 ]; then
              echo "Setting:   FTP warning message"
              funct_backup_file $message_file
              dspcat -g /usr/lib/nls/msg/en_US/ftpd.cat > /tmp/ftpd.tmp
              sed "s/\"\%s FTP server (\%s) ready.\"/\"\%s Authorised uses only. All activity may be monitored and reported\"/" /tmp/ftpd.tmp > /tmp/ftpd.msg
              gencat /usr/lib/nls/msg/en_US/ftpd.cat /tmp/ftpd.msg
              rm /tmp/ftpd.tmp /tmp/ftpd.msg
            fi
          else
            if [ "$audit_mode" = 1 ]; then
              total=`expr $total + 1`
              score=`expr $score + 1`
              echo "Secure:    FTP warning message enabled [$score]"
            fi
          fi
        else
          funct_restore_file $message_file $restore_dir
        fi
      else
        funct_verbose_message "" fix
        funct_verbose_message "Package $package_name is not installed" fix
        funct_verbose_message "" fix
      fi
    fi
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ]; then
        check_file="/etc/ftpd/banner.msg"
        funct_file_value $check_file Authorised space "users only" hash
        if [ "$audit_mode" = 0 ]; then
          funct_check_perms $check_file 0444 root root
        fi
      fi
      if [ "$os_version" = "11" ]; then
        check_file="/etc/proftpd.conf"
        funct_file_value $check_file DisplayConnect space /etc/issue hash
        if [ "$audit_mode" = 0 ]; then
          svcadm restart ftp
        fi
      fi
    fi
  fi
}
