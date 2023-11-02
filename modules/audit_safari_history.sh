# audit_safari_history
#
# Check Safari history limit
#
# Refer to Section(s) 6.3.2 Page(s) 374-79 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_safari_history () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "Safari History"
      if [ "$audit_mode" != 2 ]; then
        for user_name in `ls /Users |grep -v Shared`; do
          check_value=$( /usr/bin/sudo -u $user_name /usr/bin/defaults read /Users/$user_name/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari HistoryAgeInDaysLimit 2>&1 > /dev/null )
          if [ "$check_value" = "$safari_history" ]; then
            increment_secure "Safari History Limit for $user_name is set to $safari_history"
          else
            increment_insecure "Safari History Limit for $user_name is not set to $safari_history"
          fi
        done
      fi
    fi
  fi
}
