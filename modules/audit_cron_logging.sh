# audit_cron_logging
#
# Refer to Section(s) 4.7 Page(s) 71 CIS Solaris 10 Benchmark v5.1.0
#.

audit_cron_logging () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      verbose_message "Cron Logging"
      check_file="/etc/default/cron"
      check_file_value is $check_file CRONLOG eq YES hash
      check_file="/var/cron/log"
      check_file_perms $check_file 0640 root root
    fi
  fi
}
