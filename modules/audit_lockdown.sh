#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_lockdown
#
# When lockdown mode is enabled, specific trusted websites can be excluded from
# Lockdown protection if necessary.
#
# Refer to Section(s) 2.6.7 Page(s) 181-2 CIS Apple macOS 14 Sonoma Benchmark v1.0.0
#.

audit_lockdown () {
  if [ "${os_name}" = "Darwin" ]; then
    if [ "${long_os_version}" -ge 1014 ]; then
      verbose_message "Lockdown Mode" "check"
      if [ "${audit_mode}" != 2 ]; then
        user_list=$( find /Users -maxdepth 1 | grep -vE "localized|Shared" | cut -f3 -d/ )
        for user_name in ${user_list}; do
          check_osx_defaults_bool ".GlobalPreferences" "LDMGlobalEnabled" "1"
        done
      fi
    fi
  fi
}
