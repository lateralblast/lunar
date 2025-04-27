#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_ad_tracking
#
# Organizations should manage advertising settings on computers rather than allow users
# to configure the settings.
#
# Refer to Section(s) 2.6.4 Page(s) 170- CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_ad_tracking () {
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${long_os_version}" -ge 1014 ]; then
      verbose_message "Ad Tracking" "check"
      if [ "${audit_mode}" != 2 ]; then
        user_list=$( find /Users -maxdepth 1 |grep -vE "localized|Shared" |cut -f3 -d/ )
        for user_name in ${user_list}; do
          check_osx_defaults_user "com.apple.AdLib.plist" "allowApplePersonalizedAdvertising" "0" "bool" "${user_name}"
        done
      fi
    fi
  fi
}
