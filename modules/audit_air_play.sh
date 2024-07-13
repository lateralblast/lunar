#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_air_play
#
# AirDrop can allow malicious files to be downloaded from unknown sources. Contacts
# Only limits may expose personal information to devices in the same area.
#
# Refer to Section(s) 2.3.1.2 Page(s) 77-80 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_air_play () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$long_os_version" -ge 1014 ]; then
      verbose_message "Air Play Receiver" "check"
      if [ "$audit_mode" != 2 ]; then
        user_list=$( find /Users -maxdepth 1 |grep -vE "localized|Shared" |cut -f3 -d/ )
        for user_name in $user_list; do
          check_osx_defaults_user "com.apple.controlcenter.plist" "AirplayRecieverEnabled" "0" "bool" "currentHost" "$user_name"
        done
      fi
    fi
  fi
}
