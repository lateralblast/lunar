# audit_infrared_remote
#
# A remote could be used to page through a document or presentation, thus
# revealing sensitive information. The solution is to turn off the remote
# and only turn it on when needed
#.

audit_infrared_remote () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Apple Remote Activation"
    funct_defaults_check /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled no bool
  fi
}
