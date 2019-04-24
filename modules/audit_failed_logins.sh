# audit_failed_logins
#
# Refer to Section(s) 4.6 Page(s) 70-1 CIS Solaris 10 Benchmark v5.1.0
#.

audit_failed_logins () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      verbose_message "Failed Login Attempts"
      check_file="/etc/default/login"
      check_file_value is $check_file SYSLOG_FAILED_LOGINS eq 0 hash
      check_file="/etc/default/login"
      check_file_value is $check_file SYSLOG eq YES hash
      check_file="/etc/default/su"
      check_file_value is $check_file SYSLOG eq YES hash
    fi
  fi
}
