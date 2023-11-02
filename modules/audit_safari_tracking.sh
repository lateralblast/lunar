# audit_safari_tracking
#
# Check Safari Tracking
#
# Refer to Section(s) 6.3.4 Page(s) 385-90 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_safari_tracking () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "Safari Cross-site Tracking"
      if [ "$audit_mode" != 2 ]; then
        for user_name in `ls /Users |grep -v Shared`; do
          check_value=$( /usr/bin/sudo -u $user_name /usr/bin/defaults read /Users/$user_name/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari BlockStoragePolicy 2>&1 > /dev/null )
          if [ "$check_value" = "$safari_block_storage_policy" ]; then
            increment_secure "Safari Block Storage Policy for $user_name is set to $safari_block_storage_policy"
          else
            increment_insecure "Safari Block Storage Policy for $user_name is not set to $safari_block_storage_policy"
          fi
          check_value=$( /usr/bin/sudo -u $user_name /usr/bin/defaults read /Users/$user_name/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari WebKitStorageBlockingPolicyy 2>&1 > /dev/null )
          if [ "$check_value" = "$webkit_storage_blocking_policy" ]; then
            increment_secure "WebKit Storage Blocking Policy for $user_name is set to $webkit_storage_blocking_policy"
          else
            increment_insecure "WebKit Storage Blocking Policy for $user_name is not set to $webkit_storage_blocking_policy"
          fi
          check_value=$( /usr/bin/sudo -u $user_name /usr/bin/defaults read /Users/$user_name/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari WebKitPreferences.storageBlockingPolicy 2>&1 > /dev/null )
          if [ "$check_value" = "$webkit_prefs_storage_blocking_policy" ]; then
            increment_secure "WebKit Preferences Storage Blocking Policy for $user_name is set to $webkit_prefs_storage_blocking_policy"
          else
            increment_insecure "WebKit Preferences Storage Blocking Policy for $user_name is not set to $webkit_prefs_storage_blocking_policy"
          fi
        done
      fi
    fi
  fi
}
