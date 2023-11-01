# audit_location_services
#
# There are some use cases where it is important that the computer not be able to report
# its exact location. While the general use case is to enable Location Services, it should
# not be allowed if the physical location of the computer and the user should not be public
# knowledge.
#
# Refer to Section(s) 2.6.1.1-2 Page(s) 153-7 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_location_services () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "Location Services"
      if [ "$audit_mode" != 2 ]; then
        check_osx_defaults /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd LocationServicesEnabled 0 bool
        check_osx_defaults /Library/Preferences/com.apple.locationmenu.plist ShowSystemServices 1 bool
      fi
    fi
  fi
}
