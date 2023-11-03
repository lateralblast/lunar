# audit_siri
#
# Where "normal" user activity is already limited, Siri use should be controlled as well.
#
# Refer to Section(s) 2.5.1 Page(s) 141-8 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_siri () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "Siri Settings"
      if [ "$audit_mode" != 2 ]; then
        for user_name in `ls /Users |grep -v Shared`; do
          check_osx_defaults com.apple.assistant.support.plist 'Assistant Enabled' 0 bool $user_name
          check_osx_defaults com.apple.Siri.plist StatusMenuVisible 1 bool $user_name
          check_osx_defaults com.apple.Siri.plist LockscreenEnabled 0 bool $user_name
          check_osx_defaults com.apple.Siri.plist VoiceTriggerUserEnabled 0 bool $user_name
          check_osx_defaults com.apple.Siri.plist TypeToSiriEnabled 0 bool $user_name
        done
      fi
    fi
  fi
}
