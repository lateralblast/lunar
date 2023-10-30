# audit_usage_data
#
# Apple provides a mechanism to send diagnostic and analytics data back to Apple to
# help them improve the platform. Information sent to Apple may contain internal
# organizational information that should be controlled and not available for processing by
# Apple. Turn off all Analytics and Improvements sharing.
#
# Refer to Section(s) 2.6.3 Page(s) 164-9 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_usage_data() {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "Usage Data"
      check_osx_defaults "Library/Application Support/CrashReporter/DiagnosticMessagesHistory.plist" AutoSubmit 0 bool
      check_osx_defaults "Library/Application Support/CrashReporter/DiagnosticMessagesHistory.plist" ThirdPartyDataSubmit 0 bool
      check_file_perms "/Library/Application Support/CrashReporter/DiagnosticMessagesHistory.plist" 644 root admin
      if [ "$audit_mode" != 2 ]; then
        for user_name in `ls /Users |grep -v Shared`; do
          check_value=$( sudo -u $user_name defaults read /Users/$user_name/Library/Preferences/com.apple.assistant.support "Siri Data Sharing Opt-In Status" 2>&1 > /dev/null )
          if [ "$check_value" = "$siri_optin" ]; then
            increment_secure "Air Drop Disable for $user_name is set to $disable_airdrop"
          else
            increment_insecure "Air Drop Disable for $user_name is set to $disable_airdrop"
          fi
        done
      fi
    fi
  fi
}
