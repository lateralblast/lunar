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
          check_value=$( sudo -u $user_name defaults read com.apple.assistant.support.plist 'Assistant Enabled' 2>&1 )
          if [ "$check_value" = "$siri_assistant" ]; then
            increment_secure "Siri Assistant for $user_name is set to $siri_assistant"
          else
            increment_insecure "Siri Assistant for $user_name is not set to $siri_assistant"
          fi
          check_value=$( sudo -u $user_name defaults read com.apple.Siri.plist StatusMenuVisible 2>&1 )
          if [ "$check_value" = "$siri_status" ]; then
            increment_secure "Siri Status Menu for $user_name is set to $siri_status"
          else
            increment_insecure "Siri Status Menu for $user_name is not set to $siri_status"
          fi
          check_value=$( sudo -u $user_name defaults read com.apple.Siri.plist LockscreenEnabled 2>&1 )
          if [ "$check_value" = "$siri_lockscreen" ]; then
            increment_secure "Siri Locksreen for $user_name is set to $siri_lockscreen"
          else
            increment_insecure "Siri Locksreen for $user_name is not set to $siri_lockscreen"
          fi
          check_value=$( sudo -u $user_name defaults read com.apple.Siri.plist VoiceTriggerUserEnabled 2>&1 )
          if [ "$check_value" = "$siri_trigger" ]; then
            increment_secure "Siri Voice Trigger for $user_name is set to $siri_trigger"
          else
            increment_insecure "Siri Voice Trigger for $user_name is not set to $siri_trigger"
          fi
          check_value=$( sudo -u $user_name defaults read com.apple.Siri.plist TypeToSiriEnabled 2>&1 )
          if [ "$check_value" = "$siri_type" ]; then
            increment_secure "Siri Type for $user_name is set to $siri_type"
          else
            increment_insecure "Siri Type for $user_name is not set to $siri_type"
          fi
        done
      fi
    fi
  fi
}
