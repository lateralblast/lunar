# audit_retry_limit
#
# Refer to Section(s) 1.2.1-6 Page(s) 26-31 CIS AIX Benchmark v1.1.0
# Refer to Section(s) 6.15    Page(s) 57-9  CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 6.11    Page(s) 96-7  CIS Solaris 10 Benchmark v5.1.0
#.

audit_retry_limit () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "Retry Limit for Account Lockout"
    if [ "$os_name" = "AIX" ]; then
      check_chsec /etc/security/login.cfg default logininterval 300
      check_chsec /etc/security/login.cfg default logindisable 10
      check_chsec /etc/security/login.cfg default loginreenable 360
      check_chsec /etc/security/login.cfg usw logintimeout 30
      check_chsec /etc/security/login.cfg default logindelay 10
      check_chsec /etc/security/user default loginretries 3
    fi
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        check_file="/etc/default/login"
        check_file_value is $check_file RETRIES eq 3 hash
        check_file="/etc/security/policy.conf"
        check_file_value is $check_file LOCK_AFTER_RETRIES eq YES hash
        if [ "$os_version" = "11" ]; then
          svcadm restart svc:/system/name-service/cache
        fi
      fi
    fi
  fi
}
