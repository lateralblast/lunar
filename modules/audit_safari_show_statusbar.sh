# audit_safari_show_statusbar
#
# Check Safari Popups
#
# Refer to Section(s) 6.3.11 Page(s) 410-11 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_safari_show_statusbar () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "Safari Show Status Bar"
      if [ "$audit_mode" != 2 ]; then
        value="1"
        for user_name in `ls /Users |grep -v Shared`; do
          check_value=$( /usr/bin/sudo -u $user_name /usr/bin/defaults read /Users/$user_name/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari ShowOverlayStatusBar 2>&1 > /dev/null )
          if [ "$check_value" = "$value" ]; then
            increment_secure "Safari Show Status Bar for $user_name is set to $value"
          else
            increment_insecure "Safari Show Status Bar for $user_name is not set to $value"
          fi
        done
      fi
    fi
  fi
}
