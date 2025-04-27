#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_account_switching
#
# Disabling the administrator's and/or user's ability to log into another user's active and
# locked session prevents unauthorized persons from viewing potentially sensitive and/or
# personal information.
#
# Refer to Section(s) 5.7 Page(s) 350-1 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_account_switching () {
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${long_os_version}" -ge 1014 ]; then
      verbose_message "Administrator Account Login to Another User Session" "check"
      if [ "${audit_mode}" != 2 ]; then
        correct_value="0"
        current_value=$( /usr/bin/sudo /usr/bin/security authorizationdb read system.login.screensaver 2>&1 | /usr/bin/grep -c 'use-login-window-ui' )
        if [ "${current_value}" = "${correct_value}" ]; then
          increment_secure   "Administrator Account Login to Another User Session is set to \"${correct_value}\""
        else
          increment_insecure "Administrator Account Login to Another User Session is not set to \"${correct_value}\""
        fi
      fi
    fi
  fi
}
