# audit_password_hints
#
# Refer to Section 6.1.2 Page(s) 73-74 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_login_details () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Login display details"
    funct_defaults_check /Library/Preferences/com.apple.loginwindow RetriesUntilHint 0 int
  fi
}
