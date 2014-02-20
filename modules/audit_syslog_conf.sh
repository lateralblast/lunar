# audit_syslog_conf
#
# By default, Solaris systems do not capture logging information that is sent
# to the LOG_AUTH facility.
# A great deal of important security-related information is sent via the
# LOG_AUTH facility (e.g., successful and failed su attempts, failed login
# attempts, root login attempts, etc.).
#.

audit_syslog_conf () {
  if [ "$os_name" = "Linux" ]; then
    funct_verbose_message "SYSLOG Configuration"
    check_file="/etc/syslog.conf"
    funct_file_value $check_file "authpriv.*" tab "/var/log/secure" hash
    funct_file_value $check_file "auth.*" tab "/var/log/messages" hash
  fi
}
