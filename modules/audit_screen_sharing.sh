# audit_screen_sharing
#
# Refer to Section 2.4.3 Page(s) 40 CIS Apple OS X 10.5 Benchmark v1.1.0
#.

audit_screen_sharing() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Screen Sharing"
    check_launchctl_service com.apple.screensharing off
  fi
}
