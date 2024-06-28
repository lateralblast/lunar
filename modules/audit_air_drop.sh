#!/bin/sh

# shellcheck disable=SC2034
# shellcheck disable=SC1090
# shellcheck disable=SC2154

# audit_air_drop
#
# AirDrop can allow malicious files to be downloaded from unknown sources. Contacts
# Only limits may expose personal information to devices in the same area.
#
# Refer to Section(s) 2.3.1.1 Page(s) 72-6 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_air_drop () {
  if [ "$os_name" = "Darwin" ]; then
    if [ "$long_os_version" -ge 1014 ]; then
      verbose_message "Air Drop" "check"
      if [ "$audit_mode" != 2 ]; then
        user_list=$( find /Users -maxdepth 1 |grep -vE "localized|Shared" |cut -f3 -d/ )
        for user_name in $user_list; do
          check_osx_defaults "com.apple.NetworkBrowser" "DisableAirDrop" "1" "bool" "$user_name"
        done
      fi
    fi
  fi
}
