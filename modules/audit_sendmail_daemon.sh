# audit_sendmail_daemon
#
# Refer to Section(s) 3.16  Page(s) 82    CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 3.16  Page(s) 72-3  CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 3.5   Page(s) 10    CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 6.15  Page(s) 62-3  CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 1.3.6 Page(s) 40-1  CIS AIX Benchmark v1.1.0
# Refer to Section(s) 2.2   Page(s) 15-6  CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 2.1.4 Page(s) 19-20 CIS Solaris 10 Benchmark v5.1.0
#.

audit_sendmail_daemon() {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "Sendmail Daemon"
    if [ "$sendmail_disable" = "yes" ]; then
      if [ "$os_name" = "AIX" ]; then
        check_rctcp sendmail off
      fi
      if [ "$os_name" = "SunOS" ]; then
        if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
          service_name="svc:/network/smtp:sendmail"
          check_sunos_service $service_name disabled
        fi
        if [ "$os_version" = "10" ]; then
          service_name="sendmail"
          check_sunos_service $service_name disabled
        fi
        if [ "$os_version" = "9" ] || [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
          check_file="/etc/default/sendmail"
          check_file_value is $check_file QUEUEINTERVAL eq 15m hash
          check_append_file $check_file "MODE=" hash
        else
          check_initd_service sendmail disable
          check_file="/var/spool/cron/crontabs/root"
          check_string="0 * * * * /usr/lib/sendmail -q"
          check_append_file $check_file $check_string has
        fi
      fi
      if [ "$os_name" = "Linux" ]; then
        check_chkconfig_service sendmail 3 off
        check_chkconfig_service sendmail 5 off
        check_file="/etc/sysconfig/sendmail"
        check_file_value is $check_file DAEMON eq no hash
        check_file_value is $check_file QUEUE eq 1h hash
      fi
      if [ "$os_name" = "FreeBSD" ]; then
        check_file="/etc/rc.conf"
        if [ "$os_version" < 5 ]; then
          check_file_value is $check_file sendmail_enable eq NONE hash
        else
          if [ "$os_version" > 5 ]; then
            if [ "$os_version" = "5" ] && [ "$os_update" = "0" ]; then
              check_file_value is $check_file sendmail_enable eq NONE hash
            else
              check_file_value is $check_file sendmail_enable eq NO hash
              check_file_value is $check_file sendmail_submit_enable eq NO hash
              check_file_value is $check_file sendmail_outbound_enable eq NO hash
              check_file_value is $check_file sendmail_msp_queue_enable eq NO hash
            fi
          fi
        fi
      fi
    fi
    if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
      check_file="/etc/mail/sendmail.cf"
      if [ -f "$check_file" ]; then
        verbose_message "Sendmail Configuration"
        search_string="Addr=127.0.0.1"
        restore=0
        if [ "$audit_mode" != 2 ]; then
         verbose_message "Mail transfer agent is running in local-only mode"
          check_value=$( grep -v '^#' $check_file | grep 'O DaemonPortOptions' | awk '{print $3}' | grep '$search_string' )
          if [ "$check_value" = "$search_string" ]; then
            if [ "$audit_mode" = "1" ]; then
              increment_insecure "Mail transfer agent is not running in local-only mode"
              verbose_message "" fix
              verbose_message "cp $check_file $temp_file" fix
              verbose_message "cat $temp_file |awk 'O DaemonPortOptions=/ { print \"O DaemonPortOptions=Port=smtp, Addr=127.0.0.1, Name=MTA\"; next} { print }' > $check_file" fix
              verbose_message "rm $temp_file" fix
              verbose_message "" fix
            fi
            if [ "$audit_mode" = 0 ]; then
              backup_file $check_file
              verbose_message "Setting:   Mail transfer agent to run in local-only mode"
              cp $check_file $temp_file
              cat $temp_file |awk 'O DaemonPortOptions=/ { print "O DaemonPortOptions=Port=smtp, Addr=127.0.0.1, Name=MTA"; next} { print }' > $check_file
              rm $temp_file
            fi
          else
            if [ "$audit_mode" = "1" ]; then
              
              increment_secure "Mail transfer agent is running in local-only mode"
            fi
          fi
        fi
      else
        restore_file $check_file $restore_dir
      fi
    fi
  fi
}
