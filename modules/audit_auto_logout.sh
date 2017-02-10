# audit_auto_logout
#
# Refer to Section 5.11 Page(s) 57-58 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_auto_logout() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Autologin"
    check_osx_defaults /Library/Preferences/.GlobalPreferences com.apple.autologout.AutoLogOutDelay 0 int
  fi
}
