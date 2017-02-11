# audit_login_guest
#
# Refer to Section(s) 1.4.2.7 Page(s) 29-30 CIS Apple OS X 10.6 Benchmark v1.0.0
# Refer to Section(s) 5.7     Page(s) 135   CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_login_guest () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Guest login"
    check_dscl /Users/root AuthenticationAuthority "No such key: AuthenticationAuthority"
    check_dscl /Users/Guest AuthenticationAuthority ";basic;"
    check_dscl /Users/Guest passwd "*"
    check_dscl /Users/Guest UserShell "/sbin/nologin"
  fi
}
