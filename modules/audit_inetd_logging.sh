# audit_inetd_logging
#
# The inetd process starts Internet standard services and the "tracing" feature
# can be used to log information about the source of any network connections
# seen by the daemon.
# Rather than enabling inetd tracing for all services with "inetadm -M ...",
# the administrator has the option of enabling tracing for individual services
# with "inetadm -m <svcname> tcp_trace=TRUE", where <svcname> is the name of
# the specific service that uses tracing.
# This information is logged via syslogd (1M) and is deposited by default in
# /var/adm/messages with other system log messages. If the administrator wants
# to capture this information in a separate file, simply modify /etc/syslog.conf
# to log daemon.notice to some other log file destination.
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
