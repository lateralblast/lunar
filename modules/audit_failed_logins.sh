# audit_failed_logins
#
# The SYS_FAILED_LOGINS variable is used to determine how many failed login
# attempts occur before a failed login message is logged. Setting the value
# to 0 will cause a failed login message on every failed login attempt.
# The SYSLOG_FAILED_LOGINS parameter in the /etc/default/login file is used
# to control how many login failures are allowed before log messages are
# generated-if set to zero then all failed logins will be logged.
#.

audit_failed_logins () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      funct_verbose_message "Failed Login Attempts"
      check_file="/etc/default/login"
      funct_file_value $check_file SYSLOG_FAILED_LOGINS eq 0 hash
      check_file="/etc/default/login"
      funct_file_value $check_file SYSLOG eq YES hash
      check_file="/etc/default/su"
      funct_file_value $check_file SYSLOG eq YES hash
    fi
  fi
}
