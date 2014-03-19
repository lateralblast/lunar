# audit_password_hints
#
# Password hints are user created text displayed when an incorrect password i
# used for an account.
# Password hints make it easier for unauthorized persons to gain access to
# systems by providing information to anyone that the user provided to assist
# remembering the password. This info could include the password itself or
# other information that might be readily discerned with basic knowledge of
# the end user.
#
# Refer to Section 6.1.2 Page(s) 73-74 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_login_details () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Login display details"
    funct_defaults_check /Library/Preferences/com.apple.loginwindow RetriesUntilHint 0 int
  fi
}
