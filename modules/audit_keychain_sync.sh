# audit_keychain_sync
#
# Ensure that the iCloud keychain is used consistently with organizational requirements.
#
# Refer to ection(s) 2.1.1.1 Page(s) 41-44 CIS macOS 14 Sonoma Benchmark v1.0.0
#.

audit_keychain_sync () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "Keychain sync"
      if [ "$audit_mode" != 2 ]; then
        for user_name in `ls /Users |grep -v Shared`; do
          check_value=$( sudo -u $user_name defaults read /Users/$user_name/Library/Preferences/MobileMeAccounts |grep -B 1 KEYCHAIN_SYNC |head -1 |cut -f2 -d= |cut -f1 -d\; |sed "s/ //g" )
          if [ "$check_value" = "$keychain_sync" ]; then
            increment_secure "Keychain sync enable for $user_name is set to $keychain_sync"
          else
            increment_insecure "Keychain sync enable for $user_name is not set to $keychain_sync"
          fi
        done
      fi
    fi
  fi
}
