# audit_safari_allow_popups
#
# Check Safari Popups
#
# Refer to Section(s) 6.3.9 Page(s) 406-7 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_safari_allow_popups () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "Safari Allow Popups"
      if [ "$audit_mode" != 2 ]; then
        value="0"
        for user_name in `ls /Users |grep -v Shared`; do
          check_value=$( /usr/bin/sudo -u $user_name /usr/bin/defaults read /Users/$user_name/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari safariAllowPopups 2>&1 > /dev/null )
          if [ "$check_value" = "$value" ]; then
            increment_secure "Safari Allow Popups for $user_name is set to $value"
          else
            increment_insecure "Safari Allow Popups for $user_name is not set to $value"
          fi
        done
      fi
    fi
  fi
}
