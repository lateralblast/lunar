# audit_login_warning
#
# Refer to Section 5.19 Page(s) 67-8 CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section 5.12 Page(s) 142  CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_login_warning () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Login message warning"
    check_osx_defaults com.apple.loginwindow LoginwindowText "Authorised users only"
  fi
}
