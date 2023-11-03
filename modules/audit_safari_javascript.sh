# audit_safari_javascript
#
# Check Safari Javascript
#
# Refer to Section(s) 6.3.10 Page(s) 408-9 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_safari_javascript () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$long_os_version" -ge 1014 ]; then
      verbose_message "Safari Javascript"
      if [ "$audit_mode" != 2 ]; then
        for user_name in `ls /Users |grep -v Shared`; do
          check_osx_defaults com.apple.Safari WebKitPreferences.javaScriptEnabled 0 bool $user_name
        done
      fi
    fi
  fi
}
