# audit_login_warning
#
# Displaying an access warning that informs the user that the system is reserved
# for authorized use only, and that the use of the system may be monitored, may
# reduce a casual attacker’s tendency to target the system.
#.

audit_login_warning () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Login message warning"
    funct_defaults_check com.apple.screensaver idleTime 900 int currentHost
  fi
}
