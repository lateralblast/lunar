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
          check_osx_defaults com.apple.Safari safariAllowPopups 0 bool $user_name
        done
      fi
    fi
  fi
}
