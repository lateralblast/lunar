#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_safari_history
#
# Check Safari history limit
#
# Refer to Section(s) 6.3.2 Page(s) 374-79 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_safari_history () {
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${long_os_version}" -ge 1014 ]; then
      verbose_message "Safari History" "check"
      if [ "${audit_mode}" != 2 ]; then
        user_list=$( find /Users -maxdepth 1 | grep -vE "localized|Shared" | cut -f3 -d/ )
        for user_name in ${user_list}; do
          check_osx_defaults_user "com.apple.Safari" "HistoryAgeInDaysLimit" "31" "int" "${user_name}"
        done
      fi
    fi
  fi
}
