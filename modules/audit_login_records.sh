# audit_login_records
#
# If the file /var/adm/loginlog exists, it will capture failed login attempt
# messages with the login name, tty specification, and time. This file does
# not exist by default and must be manually created.
# Tracking failed login attempts is critical to determine when an attacker
# is attempting a brute force attack on user accounts. Note that this is only
# for login-based such as login, telnet, rlogin, etc. and does not include SSH.
# Review the loginlog file on a regular basis.
#
# Refer to Section(s) 4.5 Page(s) 69-70 CIS Solaris 10 Benchmark v5.1.0
#.

audit_login_records () {
  if [ "$os_name" = "SunOS" ]; then
    if [ "$os_version" = "10" ]; then
      funct_verbose_message "Login Records"
      audit_logadm_value loginlog none
    fi
  fi
}
