# audit_cd_sharing
#
# Refer to Section 2.4.6 Page(s) 22 CIS Apple OS X 10.8  Benchmark v1.0.0
# Refer to Section 2.4.6 Page(s) 44 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_cd_sharing() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "DVD/CD Sharing"
    if [ "$audit_mode" != 2 ]; then
      share_test=$( launchctl list | awk '{print $3}' | grep -c ODSAgent )
      if [ "$share_test" = "1" ]; then
        increment_insecure "DVD/CD sharing is enabled"
        verbose_message "" fix
        verbose_message "Open System Preferences" fix
        verbose_message "Select Sharing" fix
        verbose_message "Uncheck DVD or CD Sharing" fix
        verbose_message "" fix
      else
        increment_secure "DVD/CD Sharing is disabled"
      fi
    else
      verbose_message "" fix
      verbose_message "Open System Preferences" fix
      verbose_message "Select Sharing" fix
      verbose_message "Uncheck DVD or CD Sharing" fix
      verbose_message "" fix
    fi
  fi
}
