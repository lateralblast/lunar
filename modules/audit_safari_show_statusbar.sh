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
        for user_name in `ls /Users |grep -v Shared`; do
          check_osx_defaults com.apple.Safari ShowOverlayStatusBar 1 bool $user_name
        done
      fi
    fi
  fi
}
