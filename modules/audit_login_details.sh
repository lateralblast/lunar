# audit_login_details
#
# Displaying the names of the accounts on the computer may make breaking in
# easier. Force the user to enter a login name and password to log in.
#
# Refer to Section 6.1.1 Page(s) 72-73 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_login_details () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Login display details"
    funct_defaults_check /Library/Preferences/com.apple.loginwindow SHOWFULLNAME yes bool
  fi
}
