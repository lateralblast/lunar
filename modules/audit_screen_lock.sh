#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_screen_lock
#
# Setting an inactivity interval for the screen saver prevents unauthorized persons from
# viewing a system left unattended for an extensive period of time.
#
# Refer to Section(s) 2.3.1-2           Page(s) 13-14             CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(s) 2.3.1-2,4,5.9,11  Page(s) 32-4,7,137,140-1  CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 5.5               Page(s) 51-52             CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(s) 2.10.1            Page(s) 218-21            CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_screen_lock () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$long_os_version" -ge 1014 ]; then
      verbose_message "Screen Idle Time" "check"
      if [ "$audit_mode" != 2 ]; then
        user_list=$( find /Users -maxdepth 1 |grep -vE "localized|Shared" |cut -f3 -d/ )
        for user_name in $user_list; do
          check_osx_defaults "com.apple.screensaver" "idleTime" "600" "int" "currentHost" "$user_name"
        done
      fi
    fi
    verbose_message "Screen Lock" "check"
    check_osx_defaults "com.apple.screensaver"  "askForPassword" "1"   "int" "currentHost"
    check_osx_defaults "com.apple.screensaver"  "idleTime"       "900" "int" "currentHost"
    check_append_file  "/etc/pam.d/screensaver" "account    required     pam_group.so no_warn group=admin,wheel fail_safe"
    if [ "$audit_mode" != 2 ]; then
      if [ -f "$HOME/Library/Preferences/com.apple.dock" ]; then
        screen_test=$( defaults read ~/Library/Preferences/com.apple.dock | grep corner | grep 1 | wc -l )
        if [ "$screen_test" = "1" ]; then
          if [ "$audit_mode" = 1 ]; then
            increment_insecure "Screensaver disable hot corner is enabled"
          fi
          if [ "$audit_mode" = 1 ] || [ "$audit_mode" = 0 ]; then
            verbose_message "Open System Preferences" "fix"
            verbose_message "Mission Control" "fix"
            verbose_message "Hot Corners" "fix"
            verbose_message "Remove any corners which are set to Disable Screen Saver" "fix"
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            increment_secure "No screensaver disable hot corners enabled"
          fi
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          increment_secure "No screensaver disable hot corners enabled"
        fi
      fi
    else
      verbose_message "Open System Preferences" "fix"
      verbose_message "Mission Control" "fix"
      verbose_message "Hot Corners" "fix"
      verbose_message "Remove any corners which are set to Disable Screen Saver" "fix"
    fi
  fi
}
