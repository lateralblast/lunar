# audit_login_details
#
# Displaying the names of the accounts on the computer may make breaking in
# easier. Force the user to enter a login name and password to log in.
#.

audit_login_details () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Login display details"
    funct_defaults_check /Library/Preferences/com.apple.loginwindow SHOWFULLNAME yes bool
  fi
}
