# audit_login_details
#
# Refer to Section 6.1.1 Page(s) 72-73 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_login_details () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Login display details"
    check_osx_defaults /Library/Preferences/com.apple.loginwindow SHOWFULLNAME yes bool
  fi
}
