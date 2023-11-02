# audit_safari_javascript
#
# Check Safari Javascript
#
# Refer to Section(s) 6.3.9 Page(s) 406-7 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_safari_javascript () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "Safari Javascript"
      if [ "$audit_mode" != 2 ]; then
        value="0"
        for user_name in `ls /Users |grep -v Shared`; do
          check_value=$( /usr/bin/sudo -u $user_name /usr/bin/defaults read /Users/$user_name/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari WebKitPreferences.javaScriptEnabled 2>&1 > /dev/null )
          if [ "$check_value" = "$value" ]; then
            increment_secure "Safari Javascript for $user_name is set to $value"
          else
            increment_insecure "Safari Javascript for $user_name is not set to $value"
          fi
        done
      fi
    fi
  fi
}
