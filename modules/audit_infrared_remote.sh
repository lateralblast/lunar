# audit_infrared_remote
#
# A remote could be used to page through a document or presentation, thus
# revealing sensitive information. The solution is to turn off the remote
# and only turn it on when needed
#
# Refer to Section(s) 1.4.13.7 Page(s) 48-9 CIS Apple OS X 10.6 Benchmark v1.0.0
#.

audit_infrared_remote () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Apple Remote Activation"
    funct_defaults_check /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled no bool
  fi
}
