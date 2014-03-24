# audit_login_warning
#
# Internet Sharing uses the open source natd process to share an internet
# connection with other computers and devices on a local network.
#
# Refer to Section 2.4.2 Page(s) 17-18 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_login_warning () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Login message warning"
    funct_defaults_check /Library/Preferences/SystemConfiguration/com.apple.nat NAT Enabled dict 0 int
    funct_launchctl_check com.apple.InternetSharing off
  fi
}
