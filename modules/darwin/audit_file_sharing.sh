#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_file_sharing
#
# Refer to Section 2.4.8       Page(s) 23-4       CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section 2.4.8,6.1.4 Page(s) 46-7,158-9 CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section 2.3.3.3     Page(s) 95-7       CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_file_sharing () {
  print_function "audit_file_sharing"
  string="File Sharing"
  check_message "${string}"
  if [ "${os_name}" = "Darwin" ]; then
    check_osx_defaults_bool "/Library/Preferences/SystemConfiguration/com.apple.smb.server" "AllowGuestAccess" "no"
    check_launchctl_service "com.apple.AppleFileServer" "off"
    check_launchctl_service "nmbd"  "off"
    check_launchctl_service "smbd"  "off"
  else
    na_message "${string}"
  fi
}
