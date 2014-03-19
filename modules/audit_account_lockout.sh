# audit_account_lockout
#
# The account lockout threshold specifies the amount of times a user can
# enter a wrong password before a lockout will occur.
# The account lockout feature prevents brute-force password attacks on
# the system.
#
# Refer to Section 5.18 Page(s) 66-67 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_account_lockout() {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Account Lockout"
    funct_pwpolicy_check maxFailedLoginAttempts 3
  fi
}
