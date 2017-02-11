# audit_password_hints
#
# Refer to Section 6.1.2 Page(s) 73-4  CIS Apple OS X 10.8  Benchmark v1.0.0
# Refer to Section 6.1.2 Page(s) 154-5 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_login_details () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Login display details"
    check_osx_defaults /Library/Preferences/com.apple.loginwindow RetriesUntilHint 0 int
  fi
}
