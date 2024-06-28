#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_cd_sharing
#
# Check CD sharing
# 
# Refer to Section(s) 2.4.6   Page(s) 22   CIS Apple OS X 10.8  Benchmark v1.0.0
# Refer to Section(s) 2.4.6   Page(s) 44   CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 2.3.3.1 Page(s) 90-1 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_cd_sharing () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "DVD/CD Sharing" "check"
    if [ "$audit_mode" != 2 ]; then
      check_launchctl_service "com.apple.ODSAgent" "off"
    fi
  fi
}
