# audit_infrared_remote
#
# Refer to Section(s) 1.4.13.7 Page(s) 48-9  CIS Apple OS X 10.6 Benchmark v1.0.0
# Refer to Section(s) 2.9      Page(s) 79-80 CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to http://support.apple.com/kb/PH11060
#.

audit_infrared_remote () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Apple Remote Activation"
    check_osx_defaults /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled no bool
  fi
}
