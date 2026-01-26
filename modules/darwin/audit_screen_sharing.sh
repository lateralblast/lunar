#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_screen_sharing
#
# Check sreen sharing settings
#
# Refer to Section(s) 2.4.3   Page(s) 40   CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 2.3.3.2 Page(s) 92-4 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#
# Refer to http://support.apple.com/kb/ph11151
#.

audit_screen_sharing () {
  print_function "audit_screen_sharing]"
  if [ "${os_name}" = "Darwin" ]; then
    verbose_message         "Screen Sharing"          "check"
    check_launchctl_service "com.apple.screensharing" "off"
  fi
}
