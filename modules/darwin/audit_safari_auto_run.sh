#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_safari_auto_run
#
# Check Safari settingd
#
# Refer to Section(s) 6.3   Page(s) 78     CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(s) 6.3-4 Page(s) 164-6  CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 6.3.1 Page(s) 369-73 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_safari_auto_run () {
  print_function "audit_safari_auto_run"
  string="Safari Auto-run"
  check_message "${string}"
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${audit_mode}" != 2 ]; then
      check_osx_defaults_int    "com.apple.Safari AutoOpenSafeDownloads" "0" "int"
      check_osx_defaults_string "$HOME/Library/Preferences/com.apple.safari.plist" "PlugInFirstVisitPolicy" "PlugInPolicyAllowWithSecurityRestrictions"
    fi
  else
    na_message "${string}"
  fi
}
