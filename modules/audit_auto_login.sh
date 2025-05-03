#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_auto_login
#
# Disabling automatic login decreases the likelihood of an unauthorized person gaining
# access to a system.
#
# Refer to Section(s) 5.7       Page(s) 53-54  CIS Apple OS X 10.8 Benchmark v1.0.0
# Refer to Section(s) 5.8,6.1.1 Page(s) 152-3  CIS Apple OS X 10.12 Benchmark v1.0.0
# Refer to Section(s) 2.12.3    Page(s) 248-50 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_auto_login() {
  if [ "${os_name}" = "Darwin" ]; then
    verbose_message         "Autologin" "check"
    check_osx_defaults_bool "/Library/Preferences/.GlobalPreferences" "com.apple.userspref.DisableAutoLogin" "yes"
    if [ ! "${audit_mode}" != 2 ]; then
      defaults_check=$( defaults read /Library/Preferences/com.apple.loginwindow | grep autoLoginUser )
      if [ "${defaults_check}" ]; then
        increment_insecure  "Autologin enabled"
      else
        increment_secure    "Autologin disabled"
      fi
    fi
  fi
}