# audit_auto_login
#
# Refer to Section 5.7       Page(s) 53-54 CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section 5.8,6.1.1 Page(s) 152-3 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_auto_login() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Autologin"
    check_osx_defaults /Library/Preferences/.GlobalPreferences com.apple.userspref.DisableAutoLogin yes bool
    if [ ! "$audit_mode" != 2 ]; then
      check=$( defaults read /Library/Preferences/com.apple.loginwindow | grep autoLoginUser )
      if [ "$check" ]; then
        increment_insecure "Autologin enabled"
      else
        increment_secure "Autologin disabled"
      fi
    fi
  fi
}