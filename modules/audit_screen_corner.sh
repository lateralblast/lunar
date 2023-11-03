# audit_screen_corner
#
# Hot Corners can be configured to disable the screen saver by moving the mouse cursor
# to a corner of the screen.
#
# Refer to Section(s) 2.7.1 Page(s) 188-92 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_screen_corner () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "Screen Saver Corners"
      if [ "$audit_mode" != 2 ]; then
        for user_name in `ls /Users |grep -v Shared`; do
          for corner in wvous-tl-corner wvous-bl-corner wvous-tr-corner wvous-tr-corner; do
            check_osx_defaults com.apple.NetworkBrowser $corner 6 int $user_name
          done
        done
      fi
    fi
  fi
}
