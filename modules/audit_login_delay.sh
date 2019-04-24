# audit_login_delay
#
# Refer to Section(s) 6.10 Page(s) 53-4 CIS Solaris 11.1 Benchmark v1.0.0
# Refer to Section(s) 6.6  Page(s) 91   CIS Solaris 10 Benchmark v5.1.0
#.

audit_login_delay () {
  if [ "$os_name" = "SunOS" ]; then
    verbose_message "Delay between Failed Login Attempts"
    check_file="/etc/default/login"
    check_file_value is $check_file SLEEPTIME eq 4 hash
  fi
}
