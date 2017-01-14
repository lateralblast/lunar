# audit_logrotate
#
# Make sure logrotate is set up appropriately.
#
# The system includes the capability of rotating log files regularly to avoid
# filling up the system with logs or making the logs unmanageable large.
# The file /etc/logrotate.d/syslog is the configuration file used to rotate
# log files created by syslog or rsyslog. These files are rotated on a weekly
# basis via a cron job and the last 4 weeks are kept.
# By keeping the log files smaller and more manageable, a system administrator
# can easily archive these files to another system and spend less time looking
# through inordinately large log files.
#
# Refer to Section(s) 4.3 Page(s) 97    CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 5.3 Page(s) 120-1 CIS Red Hat Linux 6 Benchmark v1.2.0
# Refer to Section(s) 8.4 Page(s) 113-4 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 4.3 Page(s) 191   CIS Amazon Linux Benchmark v2.0.0
#.

audit_logrotate () {
  if [ "$os_name" = "Linux" ]; then
    check_file="/etc/logrotate.d/syslog"
    if [ -f "$check_file" ]; then
      funct_verbose_message "Log Rotate Configuration"
      if [ "$audit_mode" != 2 ]; then
        echo "Checking:  Logrotate is set up"
        total=`expr $total + 1`
        if [ "$os_vendor" = "SuSE" ]; then
          search_string="/var/log/warn /var/log/messages /var/log/allmessages /var/log/localmessages /var/log/firewall /var/log/acpid /var/log/NetworkManager /var/log/mail /var/log/mail.info /var/log/mail.warn /var/log/mail.err /var/log/news/news.crit /var/log/news/news.err /var/log/news/news.notice"
        else
          search_string="/var/log/messages /var/log/secure /var/log/maillog /var/log/spooler /var/log/boot.log /var/log/cron"
        fi
        check_value=`cat $check_file |grep "$search_string" |sed 's/ {//g'`
        if [ "$check_value" != "$search_string" ]; then
          insecure=`expr $insecure + 1`
          if [ "$audit_mode" = 1 ]; then
            echo "Warning:   Log rotate is not configured for $search_string [$insecure Warnings]"
            funct_verbose_message "" fix
            funct_verbose_message "cat $check_file |sed 's,.*{,$search_string {,' > $temp_file" fix
            funct_verbose_message "cat $temp_file > $check_file" fix
            funct_verbose_message "rm $temp_file" fix
            funct_verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            funct_backup_file $check_file
            echo "Removing:  Configuring logrotate"
            cat $check_file |sed 's,.*{,$search_string {,' > $temp_file
            cat $temp_file > $check_file
            rm $temp_file
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            secure=`expr $secure + 1`
            echo "Secure:    Log rotate is configured [$secure Passes]"
          fi
        fi
      else
        funct_restore_file $check_file $restore_dir
      fi
    fi
  fi
}
