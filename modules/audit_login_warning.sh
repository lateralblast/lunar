# audit_login_warning
#
# Displaying an access warning that informs the user that the system is reserved
# for authorized use only, and that the use of the system may be monitored, may
# reduce a casual attacker’s tendency to target the system.
#
# Refer to Section 5.19 Page(s) 67-68 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_login_warning () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Login message warning"
    funct_defaults_check com.apple.loginwindow LoginwindowText "Authorised users only"
  fi
}
