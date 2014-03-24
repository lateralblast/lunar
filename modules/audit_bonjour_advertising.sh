# audit_bonjour_advertising
#
# OSX writes information pertaining to system-related events to the
# file /var/log/system.log and has a configurable retention policy for
# this file.
#
# Archiving and retaining system.log for 30 or more days is beneficial in
# the event of an incident as it will allow the user to view the various
# changes to the system along with the date and time they occurred.
#
# Refer to Section 3.4-7 Page(s) 39-40 CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section 2.4.14.14 Page(s) 62-3 CIS Apple OS X 10.5 Benchmark v1.1.0
#.

audit_bonjour_advertising() {
  if [ "$os_name" = "Darwin" ]; then
    check_file="/System/Library/LaunchDaemons/com.apple.mDNSResponder.plist"
    funct_file_value $check_file "      <string>-NoMulticastAdvertisements</string>" space "" hash after "/usr/sbin/mDNSResponder"
    if [ "$osx_mdns_enable" != "yes" ]; then
      funct_launchctl_check com.apple.mDNSResponder off
      funct_launchctl_check com.apple.mDNSResponderHelper off
    fi
  fi
}
