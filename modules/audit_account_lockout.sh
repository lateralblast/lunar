# audit_account_lockout
#
# Refer to Section 5.18 Page(s) 66-67 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_account_lockout() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Account Lockout"
    check_pwpolicy maxFailedLoginAttempts 3
  fi
}
