# audit_auto_login
#
# Refer to Section 5.7 Page(s) 53-54 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_auto_login() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Autologin"
    check_osx_defaults /Library/Preferences/.GlobalPreferences com.apple.userspref.DisableAutoLogin yes bool
  fi
}
