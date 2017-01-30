# audit_remote_apple_events
#
# Refer to Section 5.20 Page(s) 68-69 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_remote_apple_events () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Remote Apple Events"
    funct_launchctl_check eppc
  fi
}
