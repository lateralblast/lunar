# audit_remote_management
#
# Refer to Section 2.2.9 Page(s) 25-6 CIS Apple OS X 10.8  Benchmark v1.0.0
# Refer to Section 2.2.9 Page(s) 48-9 CIS Apple OS X 10.12 Benchmark v1.0.0
#.

audit_remote_management() {
  if [ "$os_name" = "Darwin" ]; then
    verbose_message "Remote Management"
    if [ "$audit_mode" != 2 ]; then
      actual_value=$( launchctl list | awk '{print $3}' | grep -c ARDAgent )
      if [ "$actual_value" = "1" ]; then
        increment_insecure "Remote Management is enabled"
        verbose_message "" fix
        verbose_message "Open System Preferences" fix
        verbose_message "Select Sharing" fix
        verbose_message "Uncheck Remote Management" fix
        verbose_message "" fix
      else
        increment_secure "Remote Management is disabled"
      fi
    else
      verbose_message "" fix
      verbose_message "Open System Preferences" fix
      verbose_message "Select Sharing" fix
      verbose_message "Uncheck Remote Management" fix
      verbose_message "" fix
    fi
  fi
}
