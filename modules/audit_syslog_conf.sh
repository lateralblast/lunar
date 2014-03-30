# audit_syslog_conf
#
# By default, Solaris systems do not capture logging information that is sent
# to the LOG_AUTH facility.
# A great deal of important security-related information is sent via the
# LOG_AUTH facility (e.g., successful and failed su attempts, failed login
# attempts, root login attempts, etc.).
#
# Refer to Section(s) 3.4 Page(s) 10 CIS FreeBSD Benchmark v1.0.5
# Refer to Section(s) 5.1.1 Page(s) 104-5 CIS Red Hat Linux 5 Benchmark v2.1.0
#.

audit_syslog_conf () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    funct_verbose_message "Syslog Configuration"
    if [ "$os_name" = "Linux" ]; then
      check_file="/etc/syslog.conf"
      funct_file_value $check_file "authpriv.*" tab "/var/log/secure" hash
      funct_file_value $check_file "auth.*" tab "/var/log/messages" hash
      funct_file_value $check_file "daemon.*" tab "/var/log/daemon.log" hash
      funct_file_value $check_file "syslog.*" tab "/var/log/syslog" hash
      funct_file_value $check_file "lpr,news,uucp,local0,local1,local2,local3,local4,local5,local6.*" tab "/var/log/unused.log" hash
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      check_file="/etc/rc.conf"
      funct_file_value $check_file syslogd_flags eq -s hash
    fi
  fi
}
