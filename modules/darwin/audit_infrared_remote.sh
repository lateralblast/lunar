#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_infrared_remote
#
# Check Infrared Remote
#
# Refer to Section(s) 1.4.13.7 Page(s) 48-9  CIS Apple OS X 10.6 Benchmark v1.0.0
# Refer to Section(s) 2.9      Page(s) 79-80 CIS Apple OS X 10.12 Benchmark v1.0.0
#
# Refer to http://support.apple.com/kb/PH11060
#.

audit_infrared_remote () {
  print_function "audit_infrared_remote"
  string="Apple Remote Activation"
  check_message "${string}"
  if [ "${os_name}" = "Darwin" ]; then
    check_osx_defaults_bool "/Library/Preferences/com.apple.driver.AppleIRController" "DeviceEnabled" "no"
  else
    na_message "${string}"
  fi
}
