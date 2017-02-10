# audit_remote_login
#
# Refer to Section 2.4.5 Page(s) 42-3 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_remote_login() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Remote Login"
    check_osx_systemsetup getremotelogin off
  fi
}
