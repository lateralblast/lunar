#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_media_sharing
#
# Disabling Media Sharing reduces the remote attack surface of the system.
#
# Refer to Section(s) 2.3.3.10 Page(s) 114-7 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_media_sharing () {
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${long_os_version}" -ge 1014 ]; then
      verbose_message "Media Sharing" "check"
      if [ "${audit_mode}" != 2 ]; then
        user_list=$( find /Users -maxdepth 1 | grep -vE "localized|Shared" | cut -f3 -d/ )
        for user_name in ${user_list}; do
          check_osx_defaults_user "com.apple.amp.mediasharingd" "home-sharing-enabled" "0" "bool" "${user_name}"
        done
      fi
    fi
  fi
}
