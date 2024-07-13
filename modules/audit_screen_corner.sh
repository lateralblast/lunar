#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_screen_corner
#
# Hot Corners can be configured to disable the screen saver by moving the mouse cursor
# to a corner of the screen.
#
# Refer to Section(s) 2.7.1 Page(s) 188-92 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_screen_corner () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$long_os_version" -ge 1014 ]; then
      verbose_message "Screen Saver Corners" "check"
      if [ "$audit_mode" != 2 ]; then
        user_list=$( find /Users -maxdepth 1 |grep -vE "localized|Shared" |cut -f3 -d/ )
        for user_name in $user_list; do
          for corner in wvous-tl-corner wvous-bl-corner wvous-tr-corner wvous-tr-corner; do
            check_osx_defaults_user "com.apple.NetworkBrowser" "$corner" "6" "int" "$user_name"
          done
        done
      fi
    fi
  fi
}
