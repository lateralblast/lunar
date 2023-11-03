# audit_ad_tracking
#
# Organizations should manage advertising settings on computers rather than allow users
# to configure the settings.
#
# Refer to Section(s) 2.6.4 Page(s) 170- CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_ad_tracking () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "Ad Tracking"
      if [ "$audit_mode" != 2 ]; then
        for user_name in `ls /Users |grep -v Shared`; do
          check_osx_defaults com.apple.AdLib.plist allowApplePersonalizedAdvertising 0 bool $user_name
        done
      fi
    fi
  fi
}
