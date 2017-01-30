# audit_internet_sharing
#
# Refer to Section 2.4.2 Page(s) 17-18 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_internet_sharing () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Internet Sharing"
    funct_defaults_check /Library/Preferences/SystemConfiguration/com.apple.nat NAT Enabled dict 0 int
    funct_launchctl_check com.apple.InternetSharing off
  fi
}
