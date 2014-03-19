# audit_remote_apple_events
#
# Password hints can give an attacker a hint as well, so the option to display
# hints should be turned off. If your organization has a policy to enter a help
# desk number in the password hints areas, do not turn off the option.
#
# Refer to Section 5.20 Page(s) 68-69 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_remote_apple_events () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Remote Apple Events"
    funct_launchctl_check eppc
  fi
}
