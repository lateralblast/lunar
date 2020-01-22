# audit_login_guest
#
# Refer to Section(s) 1.4.2.7 Page(s) 29-verbose_message " CIS Apple OS X 10.6 Benchmark v1.0.0
# Refer to Section(s) 6.1.3   Page(s) 156-7 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_login_guest () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Guest login"
    check_osx_defaults /Library/Preferences/com.apple.loginwindow.plist GuestEnabled no bool 
    check_dscl /Users/Guest AuthenticationAuthority ";basic;"
    check_dscl /Users/Guest passwd "*"
    check_dscl /Users/Guest UserShell "/sbin/nologin"
  fi
}
