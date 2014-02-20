# audit_screen_lock
#
# Sometimes referred to as a screen lock this option will keep the casual user
# away from your Mac when the screen saver has started.
# If the machine automatically logs out, unsaved work might be lost. The same
# level of security is available by using a Screen Saver and the
# "Require a password to wake the computer from sleep or screen saver" option.
#.

audit_screen_lock () {
  if [ "$os_name" = "Darwin" ]; then
    funct_verbose_message "Screen lock"
    funct_defaults_check com.apple.screensaver askForPassword 1 int currentHost
    funct_defaults_check /Library/Preferences/.GlobalPreferences com.apple.autologout.AutoLogOutDelay 0 int
  fi
}
