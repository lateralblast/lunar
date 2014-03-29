# audit_sendmail_daemon
#
# If sendmail is set to local only mode, users on remote systems cannot
# connect to the sendmail daemon. This eliminates the possibility of a
# remote exploit attack against sendmail. Leaving sendmail in local-only
# mode permits mail to be sent out from the local system.
# If the local system will not be processing or sending any mail,
# disable the sendmail service. If you disable sendmail for local use,
# messages sent to the root account, such as for cron job output or audit
# daemon warnings, will fail to be delivered properly.
# Another solution often used is to disable sendmail's local-only mode and
# to have a cron job process all mail that is queued on the local system and
# send it to a relay host that is defined in the sendmail.cf file.
# It is recommended that sendmail be left in localonly mode unless there is
# a specific requirement to disable it.
#
# Refer to Section(s) 3.5 Page(s) 10 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 1.3.6 Page(s) 40-1 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 2.2 Page(s) 15-16 CIS Solaris 11.1 v1.0.0
# Refer to Section(s) 2.1.4 Page(s) 19-20 CIS Solaris 10 v5.1.0
#.

audit_sendmail_daemon() {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ] || [ "$os_name" = "AIX" ]; then
    funct_verbose_message "Sendmail Daemon"
    if [ "$sendmail_disable" = "yes" ]; then
      if [ "$os_name" = "AIX" ]; then
        funct_rctcp_check sendmail off
      fi
      if [ "$os_name" = "SunOS" ]; then
        if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
          service_name="svc:/network/smtp:sendmail"
          funct_service $service_name disabled
        fi
        if [ "$os_version" = "10" ]; then
          service_name="sendmail"
          funct_service $service_name disabled
        fi
        if [ "$os_version" = "9" ] || [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
          check_file="/etc/default/sendmail"
          funct_file_value $check_file QUEUEINTERVAL eq 15m hash
          funct_append_file $check_file "MODE=" hash
        else
          funct_initd_service sendmail disable
          check_file="/var/spool/cron/crontabs/root"
          check_string="0 * * * * /usr/lib/sendmail -q"
          funct_append_file $check_file $check_string has
        fi
      fi
      if [ "$os_name" = "Linux" ]; then
        funct_chkconfig_service sendmail 3 off
        funct_chkconfig_service sendmail 5 off
        check_file="/etc/sysconfig/sendmail"
        funct_file_value $check_file DAEMON eq no hash
        funct_file_value $check_file QUEUE eq 1h hash
      fi
      if [ "$os_name" = "FreeBSD" ]; then
        check_file="/etc/rc.conf"
        if [ "$os_version" < 5 ]; then
          funct_file_value $check_file sendmail_enable eq NONE hash
        else
          if [ "$os_version" > 5 ]; then
            if [ "$os_version" = "5" ] && [ "$os_update" = "0" ]; then
              funct_file_value $check_file sendmail_enable eq NONE hash
            else
              funct_file_value $check_file sendmail_enable eq NO hash
              funct_file_value $check_file sendmail_submit_enable eq NO hash
              funct_file_value $check_file sendmail_outbound_enable eq NO hash
              funct_file_value $check_file sendmail_msp_queue_enable eq NO hash
            fi
          fi
        fi
      fi
    fi
    if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
      check_file="/etc/mail/sendmail.cf"
      if [ -f "$check_file" ]; then
        funct_verbose_message "Sendmail Configuration"
        search_string="Addr=127.0.0.1"
        restore=0
        if [ "$audit_mode" != 2 ]; then
          echo "Checking:  Mail transfer agent is running in local-only mode"
          total=`expr $total + 1`
          check_value=`cat $check_file |grep -v '^#' |grep 'O DaemonPortOptions' |awk '{print $3}' |grep '$search_string'`
          if [ "$check_value" = "$search_string" ]; then
            if [ "$audit_mode" = "1" ]; then
              score=`expr $score - 1`
              echo "Warning:   Mail transfer agent is not running in local-only mode [$score]"
              funct_verbose_message "" fix
              funct_verbose_message "cp $check_file $temp_file" fix
              funct_verbose_message "cat $temp_file |awk 'O DaemonPortOptions=/ { print \"O DaemonPortOptions=Port=smtp, Addr=127.0.0.1, Name=MTA\"; next} { print }' > $check_file" fix
              funct_verbose_message "rm $temp_file" fix
              funct_verbose_message "" fix
            fi
            if [ "$audit_mode" = 0 ]; then
              funct_backup_file $check_file
              echo "Setting:   Mail transfer agent to run in local-only mode"
              cp $check_file $temp_file
              cat $temp_file |awk 'O DaemonPortOptions=/ { print "O DaemonPortOptions=Port=smtp, Addr=127.0.0.1, Name=MTA"; next} { print }' > $check_file
              rm $temp_file
            fi
          else
            if [ "$audit_mode" = "1" ]; then
              score=`expr $score + 1`
              echo "Secure:    Mail transfer agent is running in local-only mode [$score]"
            fi
          fi
        fi
      else
        funct_restore_file $check_file $restore_dir
      fi
    fi
  fi
}
