# audit_cron_logging
#
# Refer to Section(s) 4.7 Page(s) 71 CIS Solaris 10 Benchmark v5.1.0
#.

audit_cron_logging () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      funct_verbose_message "Cron Logging"
      check_file="/etc/default/cron"
      funct_file_value $check_file CRONLOG eq YES hash
      check_file="/var/cron/log"
      funct_check_perms $check_file 0640 root root
    fi
  fi
}
