# audit_syslog_conf
#
# By default, Solaris systems do not capture logging information that is sent
# to the LOG_AUTH facility.
# A great deal of important security-related information is sent via the
# LOG_AUTH facility (e.g., successful and failed su attempts, failed login
# attempts, root login attempts, etc.).
#
# Refer to Section 3.4 Page(s) 10 CIS FreeBSD Benchmark v1.0.5
#.

audit_syslog_conf () {
  if [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    funct_verbose_message "Syslog Configuration"
    if [ "$os_name" = "Linux" ]; then
      check_file="/etc/syslog.conf"
      funct_file_value $check_file "authpriv.*" tab "/var/log/secure" hash
      funct_file_value $check_file "auth.*" tab "/var/log/messages" hash
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      check_file="/etc/rc.conf"
      funct_file_value $check_file syslogd_flags eq -s hash
    fi
  fi
}
