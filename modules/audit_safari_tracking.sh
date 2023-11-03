# audit_safari_tracking
#
# Check Safari Tracking
#
# Refer to Section(s) 6.3.4-6 Page(s) 385-402 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_safari_tracking () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$long_os_version" -ge 1014 ]; then
      verbose_message "Safari Cross-site Tracking"
      if [ "$audit_mode" != 2 ]; then
        for user_name in `ls /Users |grep -v Shared`; do
          check_osx_defaults com.apple.Safari BlockStoragePolicy 2 int $user_name
          check_osx_defaults com.apple.Safari WebKitStorageBlockingPolicy 1 int $user_name
          check_osx_defaults com.apple.Safari WebKitPreferences.storageBlockingPolicy 1 int $user_name
          check_osx_defaults com.apple.Safari WBSPrivacyProxyAvailabilityTraffic 33422572 int $user_name
          check_osx_defaults com.apple.Safari WebKitPreferences.privateClickMeasurementEnabled 1 bool $user_name
          check_osx_defaults com.apple.Safari ShowFullURLInSmartSearchField 1 bool $user_name
        done
      fi
    fi
  fi
}
