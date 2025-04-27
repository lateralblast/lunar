#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_siri
#
# Where "normal" user activity is already limited, Siri use should be controlled as well.
#
# Refer to Section(s) 2.5.1 Page(s) 141-8 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_siri () {
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${long_os_version}" -ge 1014 ]; then
      verbose_message "Siri Settings" "check"
      if [ "${audit_mode}" != 2 ]; then
        user_list=$( find /Users -maxdepth 1 |grep -vE "localized|Shared" |cut -f3 -d/ )
        for user_name in ${user_list}; do
          check_osx_defaults_user "com.apple.Siri.plist"              "StatusMenuVisible"       "1" "bool" "${user_name}"
          check_osx_defaults_user "com.apple.Siri.plist"              "LockscreenEnabled"       "0" "bool" "${user_name}"
          check_osx_defaults_user "com.apple.Siri.plist"              "VoiceTriggerUserEnabled" "0" "bool" "${user_name}"
          check_osx_defaults_user "com.apple.Siri.plist"              "TypeToSiriEnabled"       "0" "bool" "${user_name}"
          check_osx_defaults_user "com.apple.assistant.support.plist" "Assistant Enabled"       "0" "bool" "${user_name}"
        done
      fi
    fi
  fi
}
