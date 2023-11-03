# audit_account_switching
#
# Disabling the administrator's and/or user's ability to log into another user's active and
# locked session prevents unauthorized persons from viewing potentially sensitive and/or
# personal information.
#
# Refer to Section(s) 5.7 Page(s) 350-1 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_account_switching () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$os_version" -ge 14 ]; then
      verbose_message "Administrator Account Login to Another User Session"
      if [ "$audit_mode" != 2 ]; then
        value="0"
        check_value=$( /usr/bin/sudo /usr/bin/security authorizationdb read system.login.screensaver 2>&1 | /usr/bin/grep -c 'use-login-window-ui' )
        if [ "$check_value" = "$value" ]; then
          increment_secure "Administrator Account Login to Another User Session is set to $value"
        else
          increment_insecure "Administrator Account Login to Another User Session is not set to $value"
        fi
      fi
    fi
  fi
}
