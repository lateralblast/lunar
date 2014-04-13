# audit_screen_lock
#
# Sometimes referred to as a screen lock this option will keep the casual user
# away from your Mac when the screen saver has started.
# If the machine automatically logs out, unsaved work might be lost. The same
# level of security is available by using a Screen Saver and the
# "Require a password to wake the computer from sleep or screen saver" option.
#
# Refer to Section(s) 2.3.1-2 Page(s) 13-14 CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(s) 5.5 Page(s) 51-52 CIS Apple OS X 10.8 Benchmark v1.0.0
#.

audit_screen_lock () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Screen lock"
    funct_defaults_check com.apple.screensaver askForPassword 1 int currentHost
    funct_defaults_check .GlobalPreferences com.apple.autologout.AutoLogOutDelay 0 int
    funct_defaults_check com.apple.screensaver idleTime 900 int currentHost
    if [ "$audit_mode" != 2 ]; then
      if [ -f "~/Library/Preferences/com.apple.dock" ]; then
        echo "Checking:  No screensaver disable hot corners are enabled"
        screen_test=`defaults read ~/Library/Preferences/com.apple.dock |grep corner |grep 1 |wc -l`
        if [ "$screen_test" = "1" ]; then
          if [ "$audit_mode" = 1 ]; then
            total=`expr $total + 1`
            score=`expr $score - 1`
            echo "Warning:   Screensaver disable hot corner is enabled [$score]"
          fi
          if [ "$audit_mode" = 1 ] || [ "$audit_mode" = 0 ]; then
            funct_verbose_message "" fix
            funct_verbose_message "Open System Preferences" fix
            funct_verbose_message "Mission Control" fix
            funct_verbose_message "Hot Corners" fix
            funct_verbose_message "Remove any corners which are set to Disable Screen Saver" fix
            funct_verbose_message "" fix
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            total=`expr $total + 1`
            score=`expr $score + 1`
            echo "Secure:    No screensaver disable hot corners enabled [$score]"
          fi
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          score=`expr $score + 1`
          echo "Secure:    No screensaver disable hot corners enabled [$score]"
        fi
      fi
    else
      funct_verbose_message "" fix
      funct_verbose_message "Open System Preferences" fix
      funct_verbose_message "Mission Control" fix
      funct_verbose_message "Hot Corners" fix
      funct_verbose_message "Remove any corners which are set to Disable Screen Saver" fix
      funct_verbose_message "" fix
    fi
  fi
}
