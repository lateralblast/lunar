# audit_login_root
#
# Refer to Section(s) 5.7     Page(s) 135   CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_login_root () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Root login"
    check_dscl /Users/root AuthenticationAuthority "No such key: AuthenticationAuthority"
  fi
}
