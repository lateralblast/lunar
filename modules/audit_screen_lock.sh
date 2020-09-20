# audit_screen_lock
#
# Refer to Section(s) 2.3.1-2          Page(s) 13-14            CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(s) 2.3.1-2,4,5.9,11 Page(s) 32-4,7,137,140-1 CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 5.5              Page(s) 51-52            CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_screen_lock () {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Screen lock"
    check_osx_defaults com.apple.screensaver askForPassword 1 int currentHost
    check_osx_defaults com.apple.screensaver idleTime 900 int currentHost
    check_append_file /etc/pam.d/screensaver "account    required     pam_group.so no_warn group=admin,wheel fail_safe"
    if [ "$audit_mode" != 2 ]; then
      if [ -f "~/Library/Preferences/com.apple.dock" ]; then
        screen_test=$( defaults read ~/Library/Preferences/com.apple.dock | grep corner | grep 1 | wc -l )
        if [ "$screen_test" = "1" ]; then
          if [ "$audit_mode" = 1 ]; then
            increment_insecure "Screensaver disable hot corner is enabled"
          fi
          if [ "$audit_mode" = 1 ] || [ "$audit_mode" = 0 ]; then
            verbose_message "" fix
            verbose_message "Open System Preferences" fix
            verbose_message "Mission Control" fix
            verbose_message "Hot Corners" fix
            verbose_message "Remove any corners which are set to Disable Screen Saver" fix
            verbose_message "" fix
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
      verbose_message "" fix
      verbose_message "Open System Preferences" fix
      verbose_message "Mission Control" fix
      verbose_message "Hot Corners" fix
      verbose_message "Remove any corners which are set to Disable Screen Saver" fix
      verbose_message "" fix
    fi
  fi
}
