# audit_inetd_logging
#
# Refer to Section(s) 4.1 Page(s) 66-7 CIS Solaris 10 Benchmark v5.1.0
#.

audit_inetd_logging () {
  if [ "$os_name" = "SunOS" ]; then
    check_file="/etc/default/syslogd"
    funct_file_value $check_file LOG_FROM_REMOTE eq NO hash
    if [ "$os_version" = "10" ] || [ "$os_version" = "9" ]; then
      funct_verbose_message "" fix
      funct_verbose_message "Logging inetd Connections"
      funct_verbose_message "" fix
    fi
    if [ "$os_version" = "10" ]; then
      funct_command_value inetadm tcp_trace TRUE tcp
    fi
    if [ "$os_version" = "9" ]; then
      check_file="/etc/default/inetd"
      funct_file_value $check_file ENABLE_CONNECTION_LOGGING eq YES hash
    fi
  fi
}
